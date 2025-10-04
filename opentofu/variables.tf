variable "proxmox_url" {
  description   = "API URL for Proxmox"
  type          = string
}

variable "proxmox_user" {
  description   = "Proxmox API user (e.g., api@pam!tokenid)"
  type          = string
  sensitive     = true
}

variable "proxmox_token" {
  description   = "API Token secret"
  type          = string
  sensitive     = true
}

variable "public_ssh_key" {
  description   = "Public SSH key for VM and LXC access"
  type          = string
  sensitive     = true
}

variable "linux_user" {
  description   = "User to be created on every machine"
  type          = string
  sensitive     = true
}

variable "vm_template_image" {
  description = "Cloud-Init template for VMs"
  type = string
  # default = "debian-13-genericcloud-amd64.qcow2"
  default = "lunar-server-cloudimg-amd64-disk-kvm.img"
}

variable "lxc_template_image" {
  description = "Standard LXC Container-Template für alle LXC-Module"
  type    = string
  default = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
}

variable "subnet" {
  type    = string
  default = "10.1.2"
}

variable "gateway_last_octet" {
  type    = string
  default = "1"
}

variable "vm_master_name" {
  type = string
  default = "debian13-master"
}
