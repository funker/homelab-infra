terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

resource "proxmox_lxc" "container" {
  features {
    nesting       = false
  }
  target_node     = var.target_node
  unprivileged    = var.unprivileged
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
    ip          = "${local.ip_address}/24"
    gw          = local.gateway_ip
  }

  onboot  = var.onboot

  tags = join(",", concat(var.tags, var.extra_tags))

}
