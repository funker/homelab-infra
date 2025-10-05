variable "vmid" {
  type          = number
}

variable "name" {
  type          = string
}

variable "template" {
  type          = string
}

variable "storage" {
  type          = string
}

variable "cores" {
  type          = number
  default       = 2
}

variable "memory" {
  type          = number
  default       = 2048
}

variable "unprivileged" {
  type          = bool
}

variable "target_node" {
  type          = string
}

variable "bridge" {
  type          = string
  default       = "vmbr0"
}

variable "subnet" {
  type          = string  
}

variable "gateway_last_octet" {
  type          = string
}
variable "public_ssh_key" {
  type          = string
}

variable "tags" {
  type          = list(string)
  description   = "Standard-Tags für den LXC-Container"
  default       = [ "opentofu" ]
}

variable "extra_tags" {
  type          = list(string)
  description   = "Zusätzliche Tags, die dem Container hinzugefügt werden"
  default       = []
}

variable "start_after_create" {
  type          = bool
  description   = "Soll der Container direkt nach Creation gestartet werden?"
  default       = true
}


variable "onboot" {
  description   = "Autostart des Containers / der VM nach dem Start von Proxmox"
  type          = bool
  default       = false
}