#!/bin/bash
set -eux

cd "$(dirname "$0")"

if ! command -v packer &> /dev/null; then
  echo "Packer ist nicht installiert. Bitte installieren unter https://www.packer.io/downloads"
  exit 1
fi

if [ ! -f "secrets.pkrvars.hcl" ]; then
  cp secrets.pkrvars.hcl.example secrets.pkrvars.hcl
  echo "Bitte bearbeite secrets.pkrvars.hcl mit deinen Geheimnissen."
  exit 1
fi

echo "Initialisiere Packer Plugins..."
packer init main.pkr.hcl

echo "Starte Packer Build..."
packer build -force -on-error=ask -var-file=variables.pkr.hcl -var-file=secrets.pkrvars.hcl main.pkr.hcl

echo "Build abgeschlossen."
