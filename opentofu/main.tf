# module "template_conversion" {
#   source              = "./modules/vm-template"
#   vmid                = 50000
#   target_node         = "pve-nuc"
#   name                = var.vm_master_name
# }

# module "octoprint" {
#   source              = "./modules/vm-clone"
#   vmid                = 10239
#   name                = "octoprint"
#   target_node         = "pve-nuc"
#   template_name       = var.vm_master_name
#   cores               = 2
#   memory              = 1024
#   disk_size           = "12G"
#   storage             = "local-lvm"
#   bridge              = "vmbr0"
#   user_name           = var.linux_user
#   public_ssh_key      = var.public_ssh_key
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   auto_reboot         = true
#   onboot              = false
# }

# module "conbee" {
#   source              = "./modules/vm-clone"
#   vmid                = 10243
#   name                = "conbee"
#   target_node         = "pve-nuc"
#   template_name       = var.vm_master_name
#   cores               = 2
#   memory              = 2048
#   disk_size           = "20G"
#   storage             = "local-lvm"
#   bridge              = "vmbr0"
#   user_name           = var.linux_user
#   public_ssh_key      = var.public_ssh_key
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   auto_reboot         = true
#   onboot              = true
# }

# module "homeassistant" {
#   source              = "./modules/vm-clone"
#   vmid                = 10238
#   name                = "homeassistant"
#   target_node         = "pve-nuc"
#   template_name       = var.vm_master_name
#   cores               = 2
#   memory              = 2048
#   disk_size           = "20G"
#   storage             = "local-lvm"
#   bridge              = "vmbr0"
#   user_name           = var.linux_user
#   public_ssh_key      = var.public_ssh_key
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   auto_reboot         = true
#   onboot              = true
# }


# module "docker" {
#   source              = "./modules/vm-clone"
#   vmid                = 10102
#   name                = "docker"
#   target_node         = "pve-nuc"
#   template_name       = var.vm_master_name
#   cores               = 2
#   memory              = 2048
#   disk_size           = "20G"
#   storage             = "local-lvm"
#   bridge              = "vmbr0"
#   user_name           = var.linux_user
#   public_ssh_key      = var.public_ssh_key
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   auto_reboot         = true
#   onboot              = true
# }

# module "proxmox_backup" {
#   source              = "./modules/vm-clone"
#   vmid                = 10005
#   name                = "proxmox-backup-server"
#   target_node         = "pve-nuc"
#   template_name       = var.vm_master_name
#   cores               = 2
#   memory              = 2048
#   disk_size           = "20G"
#   storage             = "local-lvm"
#   bridge              = "vmbr0"
#   user_name           = var.linux_user
#   public_ssh_key      = var.public_ssh_key
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   auto_reboot         = true
#   onboot              = true
# }

module "lxc_unifi_controller" {
  source              = "./modules/lxc"
  target_node         = "pve-nuc"
  vmid                = 10030
  name                = "unifi-controller"
  extra_tags          = ["Unifi", "Wifi", "Network"]
  start_after_create  = true
  onboot              = true
  nesting             = false
  template            = var.lxc_template_image
  root_password       = var.root_password
  storage             = "local-lvm"
  cores               = 1
  memory              = 2048
  swap                = 1024
  unprivileged        = true
  bridge              = "vmbr0"
  subnet              = var.subnet
  gateway_last_octet  = var.gateway_last_octet
  public_ssh_key      = var.public_ssh_key
  private_ssh_key     = var.private_ssh_key
}

module "lxc_pihole1" {
  source              = "./modules/lxc"
  target_node         = "pve-nuc"
  vmid                = 10011
  name                = "pihole1"
  extra_tags          = ["Pi-hole", "DNS", "DHCP", "Network"]
  start_after_create  = true
  onboot              = true
  nesting             = false
  template            = var.lxc_template_image
  root_password       = var.root_password
  storage             = "local-lvm"
  cores               = 2
  memory              = 2048
  swap                = 512
  unprivileged        = false
  bridge              = "vmbr0"
  subnet              = var.subnet
  gateway_last_octet  = var.gateway_last_octet
  public_ssh_key      = var.public_ssh_key
  private_ssh_key     = var.private_ssh_key
}

# module "lxc_pihole2" {
#   source              = "./modules/lxc"
#   target_node         = "pve-nuc"
#   vmid                = 10012
#   name                = "pihole2"
#   extra_tags          = ["Pi-hole", "DNS", "DHCP", "Network"]
#   start_after_create  = true
#   onboot              = true
#   nesting             = false
#   template            = var.lxc_template_image
#   root_password       = var.root_password
#   storage             = "local-lvm"
#   cores               = 2
#   memory              = 2048
#   swap                = 512
#   unprivileged        = false
#   bridge              = "vmbr0"
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   public_ssh_key      = var.public_ssh_key
#   private_ssh_key     = var.private_ssh_key
# }

# module "lxc_pihole3" {
#   source              = "./modules/lxc"
#   target_node         = "pve-nuc"
#   vmid                = 10013
#   name                = "pihole3"
#   extra_tags          = ["Pi-hole", "DNS", "DHCP", "Network"]
#   start_after_create  = true
#   onboot              = true
#   nesting             = false
#   template            = var.lxc_template_image
#   root_password       = var.root_password
#   storage             = "local-lvm"
#   cores               = 2
#   memory              = 2048
#   swap                = 512
#   unprivileged        = false
#   bridge              = "vmbr0"
#   subnet              = var.subnet
#   gateway_last_octet  = var.gateway_last_octet
#   public_ssh_key      = var.public_ssh_key
#   private_ssh_key     = var.private_ssh_key
# }

