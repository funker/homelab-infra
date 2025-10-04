packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_user" {
  type = string
  default = ""
  sensitive = true
}

variable "proxmox_token" {
  type = string
  default = ""
  sensitive = true
}

source "proxmox" "debian13" {
  url        = var.proxmox_url
  api_token  = var.proxmox_user
  api_secret = var.proxmox_token
  vm_id      = 9000
  cores      = 2
  memory     = 2048
  storage    = var.template_storage
  pool       = "templates"
  iso_path   = "/var/lib/vz/template/iso/debian-13-genericcloud-amd64.qcow2"
  switch_uuid = true
  clone_mode = "full"
  ssh_username = "packer"
  ssh_timeout  = "5m"
  ssh_pty      = true
  vm_name     = var.template_name

  cloud_init_user = var.linux_user
  cloud_init_ssh_authorized_keys = var.cloud_init_ssh_authorized_keys
}
