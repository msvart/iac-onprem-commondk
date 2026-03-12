terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "~> 2.15.0"
    }
  }
}

# ==============================================================================
# Data sources - look up shared vSphere infrastructure
# ==============================================================================

data "vsphere_datacenter" "this" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "this" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_datastore" "this" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.this.id
}

data "vsphere_network" "default" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.this.id
}

# Look up per-VM network overrides
data "vsphere_network" "override" {
  for_each = {
    for vm in var.vms : vm.name => vm.network
    if vm.network != null
  }

  name          = each.value
  datacenter_id = data.vsphere_datacenter.this.id
}

# Look up each unique template
data "vsphere_virtual_machine" "template" {
  for_each = { for vm in var.vms : vm.template => vm.template... }

  name          = each.key
  datacenter_id = data.vsphere_datacenter.this.id
}

# ==============================================================================
# Locals
# ==============================================================================

locals {
  vm_map = { for vm in var.vms : vm.name => vm }
}

# ==============================================================================
# Virtual Machines - clone from template
# ==============================================================================

resource "vsphere_virtual_machine" "this" {
  for_each = local.vm_map

  name             = each.value.name
  resource_pool_id = data.vsphere_compute_cluster.this.resource_pool_id
  datastore_id     = data.vsphere_datastore.this.id
  folder           = try(coalesce(each.value.folder, var.folder), null)
  annotation       = each.value.annotation

  num_cpus = each.value.cpus
  memory   = each.value.memory
  guest_id = data.vsphere_virtual_machine.template[each.value.template].guest_id

  scsi_type = data.vsphere_virtual_machine.template[each.value.template].scsi_type

  # --- Network ---
  network_interface {
    network_id   = each.value.network != null ? data.vsphere_network.override[each.value.name].id : data.vsphere_network.default.id
    adapter_type = data.vsphere_virtual_machine.template[each.value.template].network_interface_types[0]
  }

  # --- Primary disk (from template) ---
  disk {
    label            = "disk0"
    size             = coalesce(each.value.disk_size, data.vsphere_virtual_machine.template[each.value.template].disks[0].size)
    thin_provisioned = data.vsphere_virtual_machine.template[each.value.template].disks[0].thin_provisioned
  }

  # --- Additional disks ---
  dynamic "disk" {
    for_each = each.value.additional_disks != null ? each.value.additional_disks : []
    content {
      label            = "disk${disk.key + 1}"
      size             = disk.value.size
      thin_provisioned = disk.value.thin_provisioned
      unit_number      = disk.key + 1
    }
  }

  # --- Clone from template with OS customization ---
  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.value.template].id

    customize {
      linux_options {
        host_name = each.value.name
        domain    = try(coalesce(each.value.domain, var.domain), null)
      }

      network_interface {
        ipv4_address = each.value.ipv4_address
        ipv4_netmask = each.value.ipv4_netmask
      }

      ipv4_gateway    = each.value.ipv4_gateway
      dns_server_list = try(coalesce(each.value.dns_servers, var.dns_servers), null)
    }
  }

  lifecycle {
    ignore_changes = [
      clone, # Ignore clone config after initial provisioning
    ]
  }
}
