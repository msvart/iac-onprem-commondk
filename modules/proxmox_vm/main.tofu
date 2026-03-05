terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

# ==============================================================================
# Locals
# ==============================================================================

locals {
  vm_map = { for vm in var.vms : vm.name => vm }
}

# ==============================================================================
# Virtual Machines - clone from template with cloud-init
# ==============================================================================

resource "proxmox_virtual_environment_vm" "this" {
  for_each = local.vm_map

  node_name = var.node_name
  name      = each.value.name
  vm_id     = each.value.vm_id
  tags      = each.value.tags
  on_boot   = each.value.on_boot

  # --- Clone from template ---
  clone {
    vm_id = coalesce(each.value.template_id, var.template_id)
    full  = true
  }

  # --- CPU ---
  cpu {
    cores   = each.value.cores
    sockets = each.value.sockets
    type    = "x86-64-v2-AES"
  }

  # --- Memory ---
  memory {
    dedicated = each.value.memory
  }

  # --- Primary disk ---
  disk {
    interface    = "scsi0"
    size         = each.value.disk_size
    datastore_id = coalesce(each.value.datastore, var.datastore)
  }

  # --- Additional disks ---
  dynamic "disk" {
    for_each = each.value.additional_disks
    content {
      interface    = "scsi${disk.key + 1}"
      size         = disk.value.size
      datastore_id = coalesce(disk.value.datastore, var.datastore)
    }
  }

  # --- Network ---
  network_device {
    bridge  = coalesce(each.value.bridge, var.bridge)
    vlan_id = each.value.vlan_id
  }

  # --- Cloud-init ---
  initialization {
    dns {
      domain  = var.domain
      servers = coalesce(each.value.dns_servers, var.dns_servers)
    }

    ip_config {
      ipv4 {
        address = coalesce(each.value.ipv4_address, "dhcp")
        gateway = each.value.ipv4_gateway
      }
    }

    user_account {
      keys = var.ssh_public_keys
    }
  }

  lifecycle {
    ignore_changes = [
      clone,
      initialization,
    ]
  }
}
