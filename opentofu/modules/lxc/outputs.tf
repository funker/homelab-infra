# ./opentofu/opentofu/modules/lxc/outputs.tf

output "ip_address" {
  description = "Die IPv4-Adresse des LXC-Containers"
  value       = try(proxmox_lxc.container.network[0].ip, null)
}

output "hostname" {
  description = "Name des LXC-Containers"
  value       = proxmox_lxc.container.hostname
}

# Liste der Tags
output "extra_tags" {
  description = "Liste der zusätzlichen Tags des Containers"
  value       = local.all_tags
}