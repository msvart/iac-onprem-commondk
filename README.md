# iac-onprem-commondk

Demo-repository til oplæg om Infrastructure as Code for on-premises miljøer.

## Om oplægget

Dette repo er lavet som supplement til et oplæg ved
[Common.dk Virtualization](https://common.dk/events/virtualization/), hvor vi
gennemgår hvordan man kan styre on-prem infrastruktur som kode med OpenTofu.

Idéen er at du kan clone dette repo, udforske modulerne og tilpasse dem til dit
eget miljø. Alt er bygget med fokus på at være let at læse og forstå - ikke
produktionsklar kode, men et udgangspunkt du kan bygge videre på.

**Oplægsholder:** [Malthe Svart](https://dk.linkedin.com/in/malthe-svart-0a437077)
fra [PlanB](https://planb.dk)

## Hvad viser repoen?

- Modulær tilgang til IaC - ét modul per teknologi, genbrugt på tværs af miljøer
- VM-provisioning via clone fra templates (vSphere + Proxmox)
- Netværkssegmentering med VLANs (UniFi)
- DNS-management (Cloudflare)
- CI/CD med Forgejo Actions (lint, validate, plan)

## Struktur

```
├── modules/                  # Genanvendelige moduler
│   ├── cloudflare_dns/       # DNS records i Cloudflare
│   ├── proxmox_vm/           # VM-provisioning i Proxmox VE
│   ├── unifi_network/        # VLAN-konfiguration i UniFi
│   └── vsphere_vm/           # VM-provisioning i VMware vSphere
│
├── environments/             # Miljøer der bruger modulerne
│   ├── cloudflare_dns/       # DNS for example.dk
│   ├── proxmox/              # Proxmox VMs (Docker, K8s, storage)
│   ├── unifi/                # Netværkssegmentering (6 VLANs)
│   └── vsphere/              # vSphere VMs (web, db, monitoring)
│
└── .forgejo/workflows/       # CI/CD
    ├── lint.yaml             # Format + validate på push/PR
    └── plan.yaml             # tofu plan på PR
```

## Providers

| Modul | Provider | Version |
|---|---|---|
| cloudflare_dns | cloudflare/cloudflare | ~> 5 |
| vsphere_vm | vmware/vsphere | ~> 2.15.0 |
| proxmox_vm | bpg/proxmox | ~> 0.78 |
| unifi_network | paultyng/unifi | ~> 0.41 |

## Kom i gang

1. Klon repoen
2. Vælg et environment, fx `environments/proxmox/`
3. Opret en `terraform.tfvars` med dine credentials
4. Kør:

   ```bash
   tofu init
   tofu plan
   tofu apply
   ```

## Forudsætninger

- [OpenTofu](https://opentofu.org/) >= 1.6
- Adgang til den relevante platform (vSphere, Proxmox, UniFi, Cloudflare)
