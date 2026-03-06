<div align="center">

<a href="https://planb.dk">
  <img src="https://www.planb.dk/cdn/shop/files/Redlogo2016Trans_7287ea24-92d3-49e0-a1f6-d9b7d00ea89e.png?v=1614743547&width=400" alt="PlanB" width="200" />
</a>


# iac-onprem-commondk

**Infrastructure as Code for on-premises miljøer med OpenTofu**

[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.6-blue?logo=opentofu&logoColor=white)](https://opentofu.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

*Demo-repository til oplæg ved [POWER Day | Tema Virtualization](https://common.dk/events/virtualization/)*
*arrangeret af [Common Denmark](https://common.dk) — Musholm, 11. marts 2026*

</div>

## Om oplægget

Dette repo er lavet som supplement til et oplæg om Infrastructure as Code for
on-premises miljøer. Formålet er at vise, hvordan man med
[OpenTofu](https://opentofu.org/) kan styre hele sin on-prem infrastruktur som
kode — fra VM-provisioning til netværk og DNS.

Repoen er bygget til at kunne clones og udforskes. Alt er skrevet med fokus på
læsbarhed og forståelighed — ikke produktionsklar kode, men et solidt
udgangspunkt du kan bygge videre på i dit eget miljø.

> **Oplægsholder:** [Malthe Svart](https://dk.linkedin.com/in/malthe-svart-0a437077) — [PlanB](https://planb.dk)

## Hvad viser repoen?

- **Modulær IaC** — ét modul per teknologi, genbrugt på tværs af miljøer
- **VM-provisioning** — clone fra templates med OS-customization (vSphere + Proxmox)
- **Netværkssegmentering** — VLAN-konfiguration via UniFi
- **DNS-management** — Cloudflare DNS med MX, TXT, AAAA m.m.
- **CI/CD** — Forgejo Actions til lint, validate og plan

## Struktur

```
├── modules/                      Genanvendelige moduler
│   ├── cloudflare_dns/           DNS records i Cloudflare
│   ├── proxmox_vm/               VM-provisioning i Proxmox VE (clone + cloud-init)
│   ├── unifi_network/            VLAN-konfiguration i UniFi
│   └── vsphere_vm/               VM-provisioning i VMware vSphere (clone + customize)
│
├── environments/                 Miljøer der bruger modulerne
│   ├── cloudflare_dns/           DNS for example.dk (16 records)
│   ├── proxmox/                  Proxmox VMs — Docker, K8s, NAS, backup
│   ├── unifi/                    Netværkssegmentering — 6 VLANs
│   └── vsphere/                  vSphere VMs — web, DB, monitoring, mail
│
└── .forgejo/workflows/           CI/CD pipelines
    ├── lint.yaml                 tofu fmt + validate på push/PR
    └── plan.yaml                 tofu plan på PR
```

## Providers

| Modul | Provider | Version |
|:---|:---|:---|
| `cloudflare_dns` | [`cloudflare/cloudflare`](https://registry.terraform.io/providers/cloudflare/cloudflare/latest) | `~> 5` |
| `vsphere_vm` | [`vmware/vsphere`](https://registry.terraform.io/providers/hashicorp/vsphere/latest) | `~> 2.15.0` |
| `proxmox_vm` | [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest) | `~> 0.78` |
| `unifi_network` | [`paultyng/unifi`](https://registry.terraform.io/providers/paultyng/unifi/latest) | `~> 0.41` |

## Kom i gang

```bash
# 1. Klon repoen
git clone <repo-url>
cd iac-onprem-commondk

# 2. Vælg et environment
cd environments/proxmox   # eller vsphere, unifi, cloudflare_dns

# 3. Opret credentials
cat > terraform.tfvars <<EOF
proxmox_endpoint  = "https://pve.example.dk:8006"
proxmox_api_token = "user@pam!token=secret"
EOF

# 4. Kør OpenTofu
tofu init
tofu plan
tofu apply
```

## Forudsætninger

- [OpenTofu](https://opentofu.org/) >= 1.6
- Adgang til den relevante platform (vSphere, Proxmox, UniFi eller Cloudflare)

---

<div align="center">

*Lavet med OpenTofu af [PlanB](https://planb.dk) — Set IT Free*

</div>
