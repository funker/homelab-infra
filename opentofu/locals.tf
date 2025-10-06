locals {
  today = formatdate("YYYY-MM-DD", timestamp())

  # Container-IPs sammeln (angepasst an Ihre Module-Outputs)

  # Annahme: Ihre LXC-Module haben entsprechende Outputs
  container_ips = {
    # Beispiel - anpassen je nach Ihren Module-Outputs
    for name, mod in module.lxc : name => mod.ip_address
  }
}
