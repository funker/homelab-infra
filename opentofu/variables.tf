# ./variables.tf

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

variable "private_ssh_key" {
  description   = "Private SSH key for VM and LXC access"
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
  # default       = "local-lvm:base-50000-disk-0"
  default       = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
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

variable "root_password" {
  description   = "Default password for user root"
  type          = string
  sensitive     = true  
}

variable "searchdomain" {
  type          = string
  description   = "Primary search domain"
  sensitive     = true
}

variable "nameserver" {
  type          = string
  description   = "Primary name server"
  sensitive     = true
}

# # Variablen für alle Container
# variable "containers" {
#   type = map(object({
#     target_node         = string
#     vmid                = number
#     name                = string
#     template            = string
#     storage             = string
#     cores               = number
#     memory              = number
#     swap                = number
#     unprivileged        = bool
#     bridge              = string
#     subnet              = string
#     gateway_last_octet  = number
#     public_ssh_key      = string
#     private_ssh_key     = string
#     root_password       = string
#     onboot              = bool
#     start_after_create  = bool
#     extra_tags          = list(string)
#     nesting             = bool
#   }))
# }

variable "containers" {
  description = "Map minimaler Container-Overrides; Default-Felder werden per locals.container_defaults ergänzt"
  type        = map(any)
  default     = {}
}
