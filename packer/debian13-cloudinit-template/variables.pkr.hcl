# Debian 13 Packer Variables
# Diese Datei enthält alle konfigurierbaren Parameter für das Debian 13 Template

# Proxmox Konfiguration
variable "proxmox_node" {
  type        = string
  description = "Proxmox Node auf dem die VM erstellt wird"
  default     = "pve"
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

# VM Template Konfiguration
variable "vm_name" {
  type        = string
  description = "VM Template Name"
  default     = "debian-13-template"
}

variable "vm_description" {
  type        = string
  description = "VM Template Beschreibung"
  default     = "Debian 13 Trixie Template mit Cloud-Init und QEMU Guest Agent"
}

variable "vm_memory" {
  type        = number
  description = "RAM in MB"
  default     = 2048
  validation {
    condition     = var.vm_memory >= 512 && var.vm_memory <= 131072
    error_message = "Memory muss zwischen 512 MB und 128 GB liegen."
  }
}

variable "vm_cores" {
  type        = number
  description = "CPU Cores"
  default     = 2
  validation {
    condition     = var.vm_cores >= 1 && var.vm_cores <= 32
    error_message = "CPU Cores müssen zwischen 1 und 32 liegen."
  }
}

variable "vm_sockets" {
  type        = number
  description = "CPU Sockets"
  default     = 1
  validation {
    condition     = var.vm_sockets >= 1 && var.vm_sockets <= 4
    error_message = "CPU Sockets müssen zwischen 1 und 4 liegen."
  }
}

variable "vm_disk_size" {
  type        = string
  description = "Disk Size mit Einheit (z.B. 20G, 50G)"
  default     = "20G"
  validation {
    condition     = can(regex("^[0-9]+[GMK]$", var.vm_disk_size))
    error_message = "Disk Size muss im Format '20G', '50G', etc. angegeben werden."
  }
}

variable "vm_disk_type" {
  type        = string
  description = "Disk Controller Type"
  default     = "scsi"
  validation {
    condition     = contains(["scsi", "sata", "virtio", "ide"], var.vm_disk_type)
    error_message = "Disk Type muss scsi, sata, virtio oder ide sein."
  }
}

# Network Konfiguration
variable "vm_network_bridge" {
  type        = string
  description = "Network Bridge Interface"
  default     = "vmbr0"
}

variable "vm_network_model" {
  type        = string
  description = "Network Interface Model"
  default     = "virtio"
  validation {
    condition = contains([
      "rtl8139", "ne2k_pci", "e1000", "pcnet", "virtio",
      "ne2k_isa", "i82551", "i82557b", "i82559er", "vmxnet3",
      "e1000-82540em", "e1000-82544gc", "e1000-82545em"
    ], var.vm_network_model)
    error_message = "Network Model muss ein gültiger Wert sein (virtio empfohlen)."
  }
}

# SSH Provisioning Konfiguration
variable "ssh_username" {
  type        = string
  description = "SSH Username für Packer Provisioning"
  default     = "packer"
}

variable "boot_wait" {
  type        = string
  description = "Zeit die gewartet wird bevor Boot Command ausgeführt wird"
  default     = "5s"
}

variable "ssh_timeout" {
  type        = string
  description = "SSH Connection Timeout"
  default     = "20m"
}

# Debian ISO Konfiguration
variable "debian_version" {
  type        = string
  description = "Debian Version"
  default     = "13.1.0"
}

variable "debian_iso_file" {
  type        = string
  description = "Debian ISO File Path im Proxmox Storage"
  default     = "local:iso/debian-13.1.0-amd64-netinst.iso"
}

variable "debian_iso_checksum" {
  type        = string
  description = "SHA512 Checksum der Debian ISO"
  # Hinweis: Aktuellen Checksum von https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA512SUMS holen
  default     = "sha512:ed07ed3ee6ad1e63b3f8095dd4e5ddd7e7a68a2bcac623c0add0e6e9cf30b8b6e15b1074a99e0a1b5ad65b4c5b8b74b2fde6a9e97c4e6e6b3f2c9e7c3f9e7b4"
}

# Lokale Variablen für berechnete Werte
locals {
  build_timestamp = formatdate("YYYY-MM-DD-hhmm", timestamp())
  template_name   = "${var.vm_name}-${local.build_timestamp}"
}