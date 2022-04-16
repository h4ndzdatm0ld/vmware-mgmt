SHELL := /bin/bash

base_ubuntu_dir = ./packer-builds/template-build
ubuntu_vars = $(base_ubuntu_dir)/variables.pkr.hcl

# Ubuntu Build
# Base image to feed into ubuntu jobs
ubuntu_base:
	PACKER_LOG=1
	packer build -force -var "vsphere_password=$(VMWARE_PASSWORD)" $(base_ubuntu_dir)


# Terraform

base_tform_dir = ./terraform-plans/crunchy-iac/

terraform_deploy:
	terraform -chdir=$(base_tform_dir) init
	terraform -chdir=$(base_tform_dir) apply --var="vsphere_password=$(VMWARE_PASSWORD)" --var="vsphere_vm_name=$(VSPHERE_VM_NAME)" -auto-approve