variable "proxmox_url" {
  description   = "API URL für Proxmox"
  type          = string
}

variable "proxmox_user" {
  description   = "Proxmox API user (z.B., api@pam!tokenid)"
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

variable "lxc_template_image" {
  description   = "Standard LXC Container-Template für alle LXC-Module"
  type          = string
  default       = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
}

variable "unpriviledged" {
  description   = "Is the container unpriviledged?"
  type          = bool
  default       = false
}

variable "subnet" {
  description = "Default Subnetz für alle Maschinen"
  type          = string
  sensitive     = true
}

variable "gateway_last_octet" {
  type          = string
  default       = "1"
}

variable "vm_master_name" {
  description   = "Name der Template-VM, aus der neue VMs geklont werden"
  type          = string
  default       = "ubuntu-cloud"
}

variable "onboot" {
  description   = "Autostart des Containers / der VM nach dem Start von Proxmox"
  type          = bool
  default       = false
}