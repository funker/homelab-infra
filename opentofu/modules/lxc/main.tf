terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

variable "vmid" {
  type = number
}

variable "name" {
  type = string
}

variable "template" {
  type = string
}

variable "storage" {
  type = string
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "unpriviledged" {
  type = bool
}

variable "bridge" {
  type = string
  default = "vmbr0"
}

variable "subnet" {
  type = string  
}

variable "gateway_last_octet" {
  type = string
}
variable "public_ssh_key" {
  type = string
}

locals {
  ip_suffix = tonumber(substr(format("%05d", var.vmid), -3, 3))
  ip_address = "${var.subnet}.${local.ip_suffix}"
  gateway_ip = "${var.subnet}.${var.gateway_last_octet}"
}

resource "proxmox_lxc" "container" {
  features {
    nesting       = false
  }
  pool            = "terraform"
  unprivileged    = var.unpriviledged
  vmid            = var.vmid
  hostname        = var.name
  ostemplate      = var.template
  cores           = var.cores
  memory          = var.memory

  rootfs {
    storage     = var.storage
    size        = "8G"   # Größe anpassen, "8G" für 8 Gigabyte
  }

  network {
    name        = "eth0"
    bridge      = var.bridge
    ip          = "ip=${local.ip_address}/24"
    gw          = local.gateway_ip
  }

  onboot  = true
}
