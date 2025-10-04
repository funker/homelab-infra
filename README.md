# Homelab Infrastructure Code

Dieses Repository enthält die Infrastrukturdefinition für mein Homelab basierend auf OpenTofu (Terraform Fork), Proxmox, und Ansible.

***

## Struktur

- `modules/vm-clone/` - Terraform Modul zum Klonen von VMs aus vorhandenen Proxmox Templates
- `modules/lxc/` - Terraform Modul zur Erzeugung und Verwaltung von LXC-Containern in Proxmox
- `modules/vm-template/` - (optional) Modul zur Templateverwaltung (wird selten direkt verwendet)
- `root/` - Hauptkonfigurationsdateien für die Umgebung (Variablen, Moduleinbindungen)
- `ansible/` - Ansible Playbooks und Rollen zur weiteren Konfigurationsautomatisierung
- `.gitignore` - Ausschluss sensibler und temporärer Dateien

***

## Konzept

- **VM Erstellung** erfolgt ausschließlich durch Klonen von Templates (z.B. Ubuntu, Debian), die einmalig manuell oder mit Packer erstellt wurden.
- Cloud-init wird für die erste Konfiguration der VMs genutzt (User, SSH-Keys, Netzwerk).
- IP-Adressen für VMs und LXC werden automatisch aus der VMID abgeleitet über zentrale Variablen (`subnet`, `gateway_last_octet`).
- Der Proxmox Provider von OpenTofu wird zur Ressourcenverwaltung genutzt.
- Ansible ergänzt die Infrastruktur mit Software-Konfiguration und Dienstebereitstellung.

***

## Variablen zentral verwalten

Alle wichtigen Parameter (z.B. SSH-Key, Subnetz, Gateway) befinden sich in der Root-`variables.tf`. Diese werden an die Module weitergereicht.

***

## Workflow

1. Erstelle (manuell oder mit [Packer](https://www.packer.io/)) benötigte VM-Templates in Proxmox.
2. Nutze die Terraform Module zum Klonen und Verwalten von VMs (`modules/vm-clone`) und LXC-Containern (`modules/lxc`).
3. Setze `tofu apply` ein, um die Infrastruktur anzulegen und aktuell zu halten.
4. Konfiguriere die Systeme mit Ansible nach Bedarf.

***

## Packer Integration (Optional)

Ein Verzeichnis `packer/` kann zur Automatisierung der Template-Erstellung genutzt werden. Dabei wird ein Image automatisiert erstellt, konfiguriert und in Proxmox importiert.

***

## GitHub Hinweise

- `.gitignore` schützt sensible Schlüssel und Terraform-Stände.
- SSH-Key für GitHub Push und Terraform SSH-Access zentral verwalten.

***

## Kontakt \& Support

Dieses Repository ist privat gepflegt. Für Fragen oder Anregungen gerne Issues oder Kontakt.

