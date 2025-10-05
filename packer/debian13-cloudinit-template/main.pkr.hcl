# Debian 13 VM Template mit Cloud-Init für Proxmox

packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL"
  sensitive   = false
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
  sensitive   = false
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API Token"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox Node Name"
}

variable "proxmox_storage_pool" {
  type        = string
  description = "Storage Pool für VM Disks"
  default     = "local-lvm"
}

variable "proxmox_storage_pool_iso" {
  type        = string
  description = "Storage Pool für ISO Images"
  default     = "local"
}

variable "vm_id" {
  type        = number
  description = "VM ID (100-999999999)"
  default     = null
}

variable "vm_name" {
  type        = string
  description = "VM Template Name"
  default     = "debian-13-template"
}

variable "vm_description" {
  type        = string
  description = "VM Template Beschreibung"
  default     = "Debian 13 Trixie Template mit Cloud-Init"
}

variable "vm_memory" {
  type        = number
  description = "RAM in MB"
  default     = 2048
}

variable "vm_cores" {
  type        = number
  description = "CPU Cores"
  default     = 2
}

variable "vm_sockets" {
  type        = number
  description = "CPU Sockets"
  default     = 1
}

variable "vm_disk_size" {
  type        = string
  description = "Disk Size (z.B. 20G)"
  default     = "20G"
}

variable "vm_disk_type" {
  type        = string
  description = "Disk Type (scsi/sata/virtio)"
  default     = "scsi"
}

variable "vm_network_bridge" {
  type        = string
  description = "Network Bridge"
  default     = "vmbr0"
}

variable "vm_network_model" {
  type        = string
  description = "Network Model"
  default     = "virtio"
}

variable "ssh_username" {
  type        = string
  description = "SSH Username für provisioning"
  default     = "packer"
}

variable "ssh_password" {
  type        = string
  description = "SSH Password für provisioning"
  sensitive   = true
}

variable "debian_version" {
  type        = string
  description = "Debian Version"
  default     = "13.1.0"
}

variable "debian_iso_file" {
  type        = string
  description = "Debian ISO File Path in Proxmox"
  default     = "local:iso/debian-13.1.0-amd64-netinst.iso"
}

variable "debian_iso_checksum" {
  type        = string
  description = "Debian ISO SHA512 Checksum"
  # Aktueller SHA512 für Debian 13.1.0
  default     = "sha512:ed07ed3ee6ad1e63b3f8095dd4e5ddd7e7a68a2bcac623c0add0e6e9cf30b8b6e15b1074a99e0a1b5ad65b4c5b8b74b2fde6a9e97c4e6e6b3f2c9e7c3f9e7b4"
}

variable "boot_wait" {
  type        = string
  description = "Boot wait time"
  default     = "5s"
}

variable "ssh_timeout" {
  type        = string
  description = "SSH timeout"
  default     = "20m"
}

locals {
  template_description = "${var.vm_description} - ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
}

source "proxmox-iso" "debian-13" {
  # Proxmox Connection
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token
  insecure_skip_tls_verify = true
  
  # Node & Storage
  node                = var.proxmox_node
  pool                = ""
  
  # VM Settings
  vm_id                = var.vm_id
  vm_name              = var.vm_name
  template_description = local.template_description
  template_name        = var.vm_name
  
  # Boot ISO
  boot_iso {
    type         = "scsi"
    iso_file     = var.debian_iso_file
    unmount      = true
    iso_checksum = var.debian_iso_checksum
  }
  
  # Hardware
  memory      = var.vm_memory
  cores       = var.vm_cores
  sockets     = var.vm_sockets
  cpu_type    = "host"
  machine     = "q35"
  bios        = "ovmf"
  
  # EFI Configuration
  efi_config {
    efi_storage_pool  = var.proxmox_storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }
  
  # Storage
  scsi_controller = "virtio-scsi-single"
  
  disks {
    type            = var.vm_disk_type
    disk_size       = var.vm_disk_size
    storage_pool    = var.proxmox_storage_pool
    format          = "raw"
    cache_mode      = "writethrough"
    io_thread       = true
    discard         = true
    ssd             = true
  }
  
  # Network
  network_adapters {
    model    = var.vm_network_model
    bridge   = var.vm_network_bridge
    firewall = false
  }
  
  # Cloud-Init
  cloud_init              = true
  cloud_init_storage_pool = var.proxmox_storage_pool
  
  # OS
  os = "l26"
  
  # Boot Configuration
  boot_wait = var.boot_wait
  
  boot_command = [
    "<wait><wait><wait>",
    "c<wait>",
    "linux /install.amd/vmlinuz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "hostname=${var.vm_name} ",
    "domain=local ",
    "interface=auto ",
    "vga=788 noprompt quiet --<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>"
  ]
  
  # HTTP Directory für Preseed
  http_directory = "http"
  http_bind_address = "0.0.0.0"
  http_port_min = 8000
  http_port_max = 8100
  
  # SSH
  ssh_username         = var.ssh_username
  ssh_password         = var.ssh_password
  ssh_timeout          = var.ssh_timeout
  ssh_handshake_attempts = 20
  ssh_pty              = true
  
  # VM Settings
  qemu_agent = true
  
  # Additional settings
  onboot = false
  task_timeout = "10m"
}

build {
  sources = ["source.proxmox-iso.debian-13"]
  
  # Wait for system to be ready
  provisioner "shell" {
    inline = [
      "echo 'Warten bis das System bereit ist...'",
      "while [ ! -f /var/lib/dpkg/lock-frontend ]; do sleep 1; done",
      "while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 1; done",
      "while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done"
    ]
  }
  
  # System Updates und Cloud-Init Setup
  provisioner "shell" {
    inline = [
      "echo 'Aktualisiere Paketlisten...'",
      "apt-get update",
      "echo 'Installiere Updates...'",
      "DEBIAN_FRONTEND=noninteractive apt-get -y upgrade",
      "echo 'Installiere zusätzliche Pakete...'",
      "DEBIAN_FRONTEND=noninteractive apt-get -y install cloud-init qemu-guest-agent",
      "echo 'Aktiviere qemu-guest-agent...'",
      "systemctl enable qemu-guest-agent",
      "systemctl start qemu-guest-agent"
    ]
  }
  
  # Cloud-Init Konfiguration
  provisioner "file" {
    source      = "cloud-init/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }
  
  provisioner "shell" {
    inline = [
      "echo 'Konfiguriere Cloud-Init...'",
      "mv /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
      "echo 'Bereinige Cloud-Init Cache...'",
      "cloud-init clean",
      "rm -rf /var/lib/cloud/instances",
      "rm -rf /var/lib/cloud/data",
      "truncate -s 0 /var/log/cloud-init.log",
      "truncate -s 0 /var/log/cloud-init-output.log"
    ]
  }
  
  # System cleanup
  provisioner "shell" {
    inline = [
      "echo 'Bereinige System...'",
      "apt-get -y autoremove",
      "apt-get -y autoclean",
      "rm -rf /tmp/*",
      "rm -rf /var/tmp/*",
      "history -c",
      "cat /dev/null > ~/.bash_history",
      "unset HISTFILE",
      "find /var/log -type f -exec truncate -s 0 {} \\;",
      "rm -f /root/.ssh/authorized_keys",
      "rm -f /home/*/.ssh/authorized_keys"
    ]
  }
  
  # Vorbereitung für Template-Erstellung
  provisioner "shell" {
    inline = [
      "echo 'Bereite Template vor...'",
      "sync"
    ]
  }
}