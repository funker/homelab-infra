# ./opentofu/inventory.tpl

# Inventory generiert von Terraform/OpenTofu

[all]
%{ for name, ip in container_ips ~}
${name} ansible_host=${ip} ansible_user=root ansible_ssh_common_args='-o ConnectTimeout=${ssh_timeout}' ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[lxc_hosts]
%{ for name, ip in container_ips ~}
${name}
%{ endfor ~}

# Gruppen per Tag
%{ for tag, hosts in tag_groups ~}
[tag_${tag}]
%{ for host in hosts ~}
${host}
%{ endfor ~}

%{ endfor ~}
