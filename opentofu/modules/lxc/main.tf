terraform {
  required_providers {
    proxmox = {
      source      = "telmate/proxmox"
      version     = "2.9.14"
    }
  }
}

resource "proxmox_lxc" "container" {
  features {
    nesting       = var.nesting
  }
  target_node     = var.target_node
  unprivileged    = var.unprivileged
  vmid            = var.vmid
  hostname        = var.name
  ostemplate      = var.template
  cores           = var.cores
  memory          = var.memory
  swap            = var.swap
  password        = var.root_password

  description     = local.description

  rootfs {
    storage       = var.storage
    size          = "8G"   # Größe anpassen, "8G" für 8 Gigabyte
  }

  network {
    name          = "eth0"
    bridge        = var.bridge
    ip            = "${local.ip_address}/24"
    gw            = local.gateway_ip
  }

  onboot          = var.onboot
  start           = var.start_after_create

  tags            = join(",", local.all_tags)
}

resource "null_resource" "updat_apt_sources" {
  count           = var.start_after_create ? 1 : 0
  depends_on      = [proxmox_lxc.container]

  connection {
    type          = "ssh"
    host          = local.ip_address
    user          = "root"
    password      = var.root_password
    agent         = true
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update"
    ]
  }
}