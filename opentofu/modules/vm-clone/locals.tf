locals {
  ip_suffix = tonumber(substr(format("%05d", var.vmid), -3, 3))
  ip_address = "${var.subnet}.${local.ip_suffix}"
  gateway_ip = "${var.subnet}.${var.gateway_last_octet}"
}
