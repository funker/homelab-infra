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
  description   = "Autostart des Containers / der VM nach dem Start von Proxmox"
  type          = bool
  default       = false
}

variable "subnet" {
  type = string  
}

variable "gateway_last_octet" {
  type = string
}
