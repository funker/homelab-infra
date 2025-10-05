# LXC-Modul für Proxmox mit OpenTofu

Dieses Modul erstellt LXC-Container auf Proxmox VE mit flexibler Tag- und Start-Konfiguration.

## Verzeichnisstruktur

modules/
└── lxc/
├── main.tf
├── variables.tf
└── README.md


## Variablen

- `vmid` (number): Container-ID (100–9999).
- `name` (string): Hostname.
- `template` (string): Pfad zur LXC-Vorlage (z.B. `"local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"`).
- `storage` (string): Speicherpool (z.B. `"local-lvm"`).
- `cores` (number): CPU-Cores (Standard: `2`).
- `memory` (number): RAM in MB (Standard: `2048`).
- `unprivileged` (bool): Unprivilegiert? (Standard: `true`).
- `bridge` (string): Netzwerk-Bridge (Standard: `"vmbr0"`).
- `subnet` (string): Subnetz-Prefix (z.B. `"10.1.2"`).
- `gateway_last_octet` (number): Gateway-Oktett (z.B. `1`).
- `public_ssh_key` (string): SSH-Public-Key für Benutzer.
- `onboot` (bool): Autostart bei Proxmox-Neustart? (Standard: `true`).
- `start_after_create` (bool): Start direkt nach Creation? (Standard: `true`).
- `tags` (list(string)): Basis-Tags (Standard: `["terraform"]`).
- `extra_tags` (list(string)): Weitere Tags (Standard: `[]`).

## Usage

module "lxc_pihole1" {
    source = "./modules/lxc"
    vmid = 10248
    name = "pihole1"
    template = var.lxc_template_image
    storage = "local-lvm"
    cores = 2
    memory = 2048
    unprivileged = false
    bridge = "vmbr0"
    subnet = var.subnet
    gateway_last_octet = var.gateway_last_octet
    public_ssh_key = var.public_ssh_key
    onboot = true
    start_after_create = true
    extra_tags = ["pihole","dns"]
}


## Tags und Start-Verhalten

- `tags` und `extra_tags` werden per `join(",", ...)` als CSV an Proxmox übergeben.
- `onboot` setzt den Autostart bei Host-Reboot.
- `start_after_create` startet den Container unmittelbar nach Provisionierung.

## Plan & Apply

tofu init -upgrade
tofu plan -out=plan.tfplan
tofu apply plan.tfplan


Damit haben Sie ein schlankes, wartungsarmes LXC-Modul mit klarer Variablenstruktur und automatischem Startverhalten.
