# LXC containers

# Variablen für alle Container
variable "containers" {
  type = map(object({
    target_node         = string
    vmid                = number
    name                = string
    template            = string
    storage             = string
    cores               = number
    memory              = number
    swap                = number
    unprivileged        = bool
    bridge              = string
    subnet              = string
    gateway_last_octet  = number
    public_ssh_key      = string
    private_ssh_key     = string
    root_password       = string
    onboot              = bool
    start_after_create  = bool
    extra_tags          = list(string)
    nesting             = bool
  }))
}

module "lxc" {
  source = "./modules/lxc"
  for_each = var.containers

  target_node         = each.value.target_node
  vmid                = each.value.vmid
  name                = each.value.name
  template            = each.value.template
  storage             = each.value.storage
  cores               = each.value.cores
  memory              = each.value.memory
  swap                = each.value.swap
  unprivileged        = each.value.unprivileged
  bridge              = each.value.bridge
  subnet              = each.value.subnet
  searchdomain        = each.value.searchdomain
  nameserver          = each.value.nameserver
  gateway_last_octet  = each.value.gateway_last_octet
  public_ssh_key      = each.value.public_ssh_key
  private_ssh_key     = each.value.private_ssh_key
  root_password       = each.value.root_password
  onboot              = each.value.onboot
  start_after_create  = each.value.start_after_create
  extra_tags          = each.value.extra_tags
  nesting             = each.value.nesting
}

# Inventory-Template rendern
data "template_file" "ansible_inventory" {
  # template = file("${path.module}/inventory.tpl")
  template = file("${path.module}/inventory.tpl")
  vars = {
    container_ips = local.container_ips
  }
}

# Inventory-Datei ins Ansible-Verzeichnis schreiben
resource "local_file" "inventory_file" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/../ansible/inventory.ini"
}

# Ansible nach LXC-Erstellung ausführen
# resource "null_resource" "run_ansible" {
#   triggers = {
#     always_run     = timestamp()
#     inventory_hash = sha1(data.template_file.ansible_inventory.rendered)
#   }

#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbooks/site.yml"
#     working_dir = "${path.module}/../ansible"
#   }

#   depends_on = [
#     local_file.inventory_file,
#     # Hier alle Ihre LXC-Module eintragen
#   ]
# }
