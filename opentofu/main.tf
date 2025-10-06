# ./opentofu/main.tf

# LXC containers

module "lxc" {
  source = "./modules/lxc"
  for_each = local.container_cfg

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

# Inventory-Datei ins Ansible-Verzeichnis schreiben
resource "local_file" "inventory_file" {
  content  = local.ansible_inventory
  filename = "${path.module}/../ansible/inventory.ini"
}

# Ansible nach LXC-Erstellung ausführen
resource "null_resource" "run_ansible" {
  triggers = {
    always_run     = timestamp()
    inventory_hash = sha1(local.ansible_inventory)
  }

  provisioner "local-exec" {
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini --ask-vault-pass playbooks/main.yml"
    working_dir = "${path.module}/../ansible"
  }

  depends_on = [
    local_file.inventory_file,
    module.lxc,
  ]
}
