#!/bin/bash
# 1. Infrastructure provisioning
cd opentofu && tofu apply

# 2. System configuration
cd ../ansible && ansible-playbook playbooks/infrastructure.yml

# 3. Docker stack deployment
ansible-playbook playbooks/docker-deploy.yml
