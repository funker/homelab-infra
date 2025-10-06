[lxc_hosts]
%{ for name, ip in container_ips ~}
{{ name }} ansible_host={{ ip }} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}
