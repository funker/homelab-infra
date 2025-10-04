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

variable "target_node" {
  type = string
}

variable "template_name" {
  type = string
}

# variable "ip" {
#   type = string
# }

variable "user_name" {
  type = string
}

variable "public_ssh_key" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "storage" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "bridge" {
  type = string
}

variable "auto_reboot" {
  type    = bool
  default = true
}

variable "onboot" {
  type = bool
  default = false
  
}

variable "subnet" {
  type = string  
}

variable "gateway_last_octet" {
  type = string
}

locals {
  ip_suffix = tonumber(substr(format("%05d", var.vmid), -3, 3))
  ip_address = "${var.subnet}.${local.ip_suffix}"
  gateway_ip = "${var.subnet}.${var.gateway_last_octet}"
}

resource "proxmox_vm_qemu" "clone" {
  vmid        = var.vmid
  name        = var.name
  target_node = var.target_node

  clone      = var.template_name
  full_clone = true

  cpu {
    cores   = var.cores
    sockets = 1
    type    = "host"
  }
  memory  = var.memory
  agent   = 1

  network {
    id     = 0
    bridge = var.bridge
    model  = "virtio"
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size      = var.disk_size
          storage   = var.storage
          iothread  = true
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = var.storage
        }
      }
    }
  }

  onboot          = var.onboot
  automatic_reboot = var.auto_reboot

  ciuser  = var.user_name
  sshkeys = var.public_ssh_key

  ipconfig0 = "ip=${local.ip_address}"
}
