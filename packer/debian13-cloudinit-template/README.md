# Debian 13 Packer Template - README

Dieses Packer Template erstellt ein Debian 13 (Trixie) VM Template für Proxmox VE mit Cloud-Init Unterstützung.

## Verzeichnisstruktur

```
.
├── main.pkr.hcl                 # Hauptkonfiguration
├── variables.pkr.hcl            # Variable Definitionen  
├── secrets.pkrvars.hcl          # Geheime Konfiguration (nicht committen!)
├── http/
│   └── preseed.cfg              # Debian Preseed Konfiguration
├── cloud-init/
│   └── 99-pve.cfg               # Cloud-Init Proxmox Konfiguration
├── .gitignore                   # Git ignore Datei
└── README.md                    # Diese Datei
```

## Voraussetzungen

### 1. Packer Installation
```bash
# Ubuntu/Debian
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer

# Oder mittels Download
wget https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip
unzip packer_1.9.4_linux_amd64.zip
sudo mv packer /usr/local/bin/
```

### 2. Proxmox API Token
```bash
# In Proxmox Web Interface:
# Datacenter > Permissions > API Tokens
# Erstelle Token: packer@pve!packer-token
# Privileged: Yes (oder entsprechende Permissions setzen)
```

### 3. Debian 13 ISO herunterladen
```bash
# Auf Proxmox Server
cd /var/lib/vz/template/iso/
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso
```

## Konfiguration

### 1. secrets.pkrvars.hcl anpassen
```hcl
proxmox_api_url      = "https://your-proxmox.local:8006/api2/json"
proxmox_api_token_id = "packer@pve!packer-token"  
proxmox_api_token    = "your-api-token-here"
ssh_password         = "packer123"
```

### 2. variables.pkrvars.hcl überprüfen/anpassen
Standardwerte können über variables.pkrvars.hcl oder direkt in secrets.pkrvars.hcl überschrieben werden.

## Verwendung

### 1. Plugin initialisieren
```bash
packer init main.pkr.hcl
```

### 2. Konfiguration validieren  
```bash
packer validate -var-file=secrets.pkrvars.hcl main.pkr.hcl
```

### 3. Template erstellen
```bash
packer build -var-file=secrets.pkrvars.hcl main.pkr.hcl
```

### 4. Template mit benutzerdefinierten Werten
```bash
packer build \
  -var-file=secrets.pkrvars.hcl \
  -var="vm_name=debian-13-custom" \
  -var="vm_memory=4096" \
  -var="vm_cores=4" \
  main.pkr.hcl
```

## Features

- **Debian 13 Trixie** mit aktuellen Updates
- **Cloud-Init** vollständig konfiguriert
- **QEMU Guest Agent** installiert und aktiviert
- **UEFI Boot** mit SecureBoot Support
- **Virtio-SCSI** für optimale Performance
- **Automatische Partitionierung** mit LVM
- **SSH Server** vorkonfiguriert
- **Template-optimiert** (Logs bereinigt, keine User-Daten)

## VM Template Klonen

Nach erfolgreichem Build können Sie das Template klonen:

```bash
# Via Proxmox Web Interface oder CLI
qm clone 900 1001 --name debian-13-test --full

# Cloud-Init konfigurieren
qm set 1001 --ciuser debian --sshkey ~/.ssh/id_rsa.pub
qm set 1001 --ipconfig0 ip=192.168.1.100/24,gw=192.168.1.1
qm set 1001 --nameserver 192.168.1.1

# VM starten
qm start 1001
```

## Troubleshooting

### Häufige Probleme

1. **ISO nicht gefunden**
   - Prüfen Sie den Pfad in `debian_iso_file`
   - ISO muss im Proxmox Storage verfügbar sein

2. **SSH Timeout**
   - Erhöhen Sie `ssh_timeout`
   - Prüfen Sie Netzwerkkonfiguration

3. **Preseed Fehler**
   - Prüfen Sie http/preseed.cfg Syntax
   - Logfiles in VM: /var/log/installer/

4. **Cloud-Init funktioniert nicht**
   - Prüfen Sie cloud-init/99-pve.cfg
   - Nach Template-Klon: `cloud-init status`

## Anpassungen

### Zusätzliche Pakete installieren
Bearbeiten Sie in `http/preseed.cfg` die Zeile:
```
d-i pkgsel/include string openssh-server sudo curl ...
```

### Custom Provisioning
Fügen Sie weitere Provisioner in `main.pkr.hcl` hinzu:
```hcl
provisioner "shell" {
  inline = [
    "echo 'Custom setup commands here'"
  ]
}
```

## Sicherheit

- `secrets.pkrvars.hcl` nie in Git committen
- API Token mit minimalen Rechten erstellen
- SSH Keys statt Passwörtern verwenden
- Template nach Erstellung testen

## Support

Für Probleme und Fragen:
1. Prüfen Sie Packer Debug Logs: `PACKER_LOG=1 packer build ...`  
2. Proxmox VM Logs überprüfen
3. Debian Installer Logs in der VM prüfen

## Lizenz

Dieses Template steht unter der MIT Lizenz zur freien Verfügung.