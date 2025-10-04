terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

variable "vmid" {
  type = number
}

variable "target_node" {
  type = string
}

variable "name" {
  type = string
}

resource "null_resource" "convert_to_template" {
  triggers = {
    vmid = var.vmid
  }

  provisioner "local-exec" {
    command = "qm shutdown ${var.vmid} && qm template ${var.vmid}"
    interpreter = ["/bin/bash", "-c"]
  }
}
