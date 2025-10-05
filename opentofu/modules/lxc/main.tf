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

  tags = join(",", concat(var.tags, var.extra_tags))

}

resource "null_resource" "enable_serial_getty" {
  count           = var.start_after_create ? 1 : 0
  depends_on      = [proxmox_lxc.container]

  connection {
    type          = "ssh"
    host          = local.ip_address
    user          = "root"
    agent         = true
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y systemd",
      "systemctl enable getty@ttyS0.service",
      "systemctl start  getty@ttyS0.service"
    ]
  }
}