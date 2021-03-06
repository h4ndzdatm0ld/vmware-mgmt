#!/bin/bash
sleep 30
# Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
# Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
sleep 10
apt-get update && apt-get install packer terraform -y
