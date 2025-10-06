# ./opentofu/locals.tf

locals {
  today = formatdate("YYYY-MM-DD", timestamp())

  # Basis-Konfiguration für alle Container
  container_defaults = {
    template           = var.lxc_template_image
    subnet             = var.subnet
    searchdomain       = var.searchdomain
    nameserver         = var.nameserver
    gateway_last_octet = var.gateway_last_octet
    public_ssh_key     = var.public_ssh_key
    private_ssh_key    = var.private_ssh_key
    root_password      = var.root_password
  }

  # Container-IPs sammeln (angepasst an Ihre Module-Outputs)
  container_ips = {
    for name, mod in module.lxc :
    name => split("/", mod.ip_address)[0]   # <-- Nur Adresse vor "/" behalten
    if mod.ip_address != null
  }


  # Map host → list(string) Tags (aus Modul-Output)
  host_tags = {
    for name, mod in module.lxc :
    name => mod.extra_tags
  }

  # Invertierte Map: tag → list(string) Hosts
  tag_groups = {
    for tag, _ in distinct(flatten(values(local.host_tags))) :
    tag => [
      for name, tags in local.host_tags :
      name if contains(tags, tag)
    ]
  }

  # Generiere Ansible inventory file
  raw_inventory = templatefile(
    "${path.module}/inventory.tpl",
    {
      container_ips = local.container_ips
      tag_groups    = local.tag_groups
      linux_user    = var.linux_user
      ssh_timeout   = var.ssh_timeout
    }
  )

  # Pfad in der ersten Zeile ersetzen
  ansible_inventory = replace(
    local.raw_inventory,
    "# ./opentofu/inventory.tpl",
    "# ./ansible/inventory.ini"
  )

  # Merge Defaults mit Overrides aus var.containers
  container_cfg = {
    for name, cfg in var.containers :
    name => merge(local.container_defaults, cfg)
  }
}
