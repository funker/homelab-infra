locals {
  ip_suffix   = tonumber(substr(format("%05d", var.vmid), -3, 3))
  ip_address  = "${var.subnet}.${local.ip_suffix}"
  gateway_ip  = "${var.subnet}.${var.gateway_last_octet}"
  
  today = formatdate("YYYY-MM-DD", timestamp())

  # Automatische OS-Tags basierend auf dem Template-Namen
  os_tags = compact([
    strcontains(lower(var.template), "ubuntu") ? "Ubuntu" : "",
    strcontains(lower(var.template), "debian") ? "Debian" : "",
    strcontains(lower(var.template), "centos") ? "CentOS" : "",
    strcontains(lower(var.template), "rocky") ? "Rocky" : "",
    strcontains(lower(var.template), "alma") ? "AlmaLinux" : "",
    strcontains(lower(var.template), "alpine") ? "Alpine" : "",
    strcontains(lower(var.template), "fedora") ? "Fedora" : "",
    strcontains(lower(var.template), "opensuse") ? "OpenSUSE" : "",
    strcontains(lower(var.template), "arch") ? "Arch" : ""
  ])
  
  # Alle Tags kombinieren: Basis-Tags + Extra-Tags + OS-Tags
  all_tags = concat(var.tags, var.extra_tags, local.os_tags)

  description = "Info:\n- Created by: OpenTofu\n- Date: ${local.today}\n- CT template image ${var.template}\n- OS: ${local.os_tags}"
}
