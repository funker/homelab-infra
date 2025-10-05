terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
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
