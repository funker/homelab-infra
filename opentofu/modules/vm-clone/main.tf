# ./opentofu/modules/lxc/main.tf

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
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
    id     = 0 # Fehler: Unexpected attribute: An attribute named "id" is not expected here
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
