packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_api_token_id" {
  type = string
  default = ""
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type = string
  default = ""
  sensitive = true
}

source "proxmox" "debian13" {
  url        = var.proxmox_address
  api_token  = var.proxmox_api_token_id
  api_secret = var.proxmox_api_token_secret
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

  cloud_init_user = "ubuntu"
  cloud_init_ssh_authorized_keys = ["ssh-rsa AAAA...user-public-key..."]
}
