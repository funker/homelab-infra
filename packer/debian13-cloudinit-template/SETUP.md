# Setup-Anleitung für Debian 13 Packer Template

## Schritt-für-Schritt Setup

### 1. Verzeichnisstruktur erstellen
```bash
mkdir -p debian-13-packer-template/{http,cloud-init}
cd debian-13-packer-template
```

### 2. Dateien erstellen

Kopieren Sie die folgenden Dateien in Ihr Projektverzeichnis:

```
debian-13-packer-template/
├── main.pkr.hcl                 # Hauptkonfiguration
├── variables.pkr.hcl            # Variable Definitionen
├── secrets.pkrvars.hcl          # Geheime Konfiguration (anpassen!)
├── http/
│   └── preseed.cfg              # Debian Preseed Konfiguration
├── cloud-init/
│   └── 99-pve.cfg               # Cloud-Init Proxmox Konfiguration
├── .gitignore                   # Git ignore Datei
└── README.md                    # Dokumentation
```

### 3. Debian 13.1.0 ISO herunterladen
```bash
# Auf Proxmox Server (als root)
cd /var/lib/vz/template/iso/
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso

# Checksum verifizieren
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA512SUMS
sha512sum -c SHA512SUMS 2>/dev/null | grep debian-13.1.0-amd64-netinst.iso
# Output sollte sein: debian-13.1.0-amd64-netinst.iso: OK
```

### 4. Proxmox API Token erstellen
```bash
# In Proxmox Web UI:
# 1. Datacenter > Permissions > API Tokens
# 2. Add > Token ID: packer@pve!packer-token
# 3. Privileged: Yes (oder spezifische Permissions vergeben)
# 4. Token notieren für secrets.pkrvars.hcl
```

### 5. secrets.pkrvars.hcl konfigurieren
```hcl
# Anpassen an Ihre Umgebung!
proxmox_api_url      = "https://ihr-proxmox-server.local:8006/api2/json"
proxmox_api_token_id = "packer@pve!packer-token"
proxmox_api_token    = "xxxx-xxxx-xxxx-xxxx"  # Ihr Token hier
ssh_password         = "packer123"
proxmox_node         = "ihr-node-name"        # z.B. "pve"
```

### 6. Erstellen Sie die HTTP-Dateien
```bash
# http/preseed.cfg mit dem bereitgestellten Inhalt erstellen
mkdir -p http
cat > http/preseed.cfg << 'EOF'
#_preseed_V1
# (Kompletter Preseed Inhalt von oben)
EOF
```

### 7. Erstellen Sie die Cloud-Init Konfiguration
```bash
# cloud-init/99-pve.cfg erstellen
mkdir -p cloud-init
cat > cloud-init/99-pve.cfg << 'EOF'
# (Kompletter Cloud-Init Inhalt von oben)
EOF
```

### 8. Packer Build ausführen
```bash
# Plugin initialisieren
packer init main.pkr.hcl

# Konfiguration validieren
packer validate -var-file=secrets.pkrvars.hcl main.pkr.hcl

# Template erstellen (ca. 15-30 Minuten)
packer build -var-file=secrets.pkrvars.hcl main.pkr.hcl
```

### 9. Template testen
```bash
# VM aus Template klonen (via Proxmox CLI)
qm clone 900 1001 --name debian-13-test --full

# Cloud-Init konfigurieren
qm set 1001 --ciuser debian
qm set 1001 --sshkey ~/.ssh/id_rsa.pub
qm set 1001 --ipconfig0 ip=dhcp

# VM starten
qm start 1001

# SSH test (nach ca. 2-3 Minuten)
ssh debian@vm-ip-adresse
```

## Wichtige Checksumme (aktuell)

**Debian 13.1.0 netinst SHA512:**
```
873e9aa09a913660b4780e29c02419f8fb91012c8092e49dcfe90ea802e60c82dcd6d7d2beeb92ebca0570c49244eee57a37170f178a27fe1f64a334ee357332
```

## Troubleshooting Tipps

1. **Boot Command Probleme:** Überprüfen Sie den Boot-Command in main.pkr.hcl
2. **SSH Timeout:** Erhöhen Sie ssh_timeout auf 30m
3. **ISO nicht gefunden:** Prüfen Sie debian_iso_file Pfad
4. **HTTP Server:** Prüfen Sie dass port 8000-8100 nicht blockiert sind

## Anpassungen für Ihre Umgebung

- **Storage Pool:** Ändern Sie `proxmox_storage_pool` in secrets.pkrvars.hcl
- **Network Bridge:** Ändern Sie `vm_network_bridge` falls nicht vmbr0
- **VM Resources:** Passen Sie Memory/CPU in variables.pkr.hcl an
- **Zusätzliche Pakete:** Erweitern Sie pkgsel/include in preseed.cfg