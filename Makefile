SHELL := /bin/bash

base_ubuntu_dir = ./packer-builds/template-build
ubuntu_vars = $(base_ubuntu_dir)/variables.pkr.hcl

# git

git_checkout_push:
	git checkout -b $(VSPHERE_VM_NAME)
	git add .
	git commit -m "Adding $(VSPHERE_VM_NAME)"
	git push --set-upstream origin $(VSPHERE_VM_NAME)

# Ubuntu Build
# Base image to feed into ubuntu jobs
ubuntu_base:
	PACKER_LOG=1
	packer init $(base_ubuntu_dir)
	packer build -force -var "vsphere_password=$(VSPHERE_PASSWORD)" $(base_ubuntu_dir)

# Terraform
base_tform_dir = ./terraform-plans

terraform_pre_clean:
	rm -rf $(base_tform_dir)/$(VSPHERE_VM_NAME)

terraform_copy:
	cp -r $(base_tform_dir)/crunchy-iac $(base_tform_dir)/$(VSPHERE_VM_NAME)/
	rm -rf $(base_tform_dir)/$(VSPHERE_VM_NAME)/.terraform
	rm $(base_tform_dir)/$(VSPHERE_VM_NAME)/.terraform.lock.hcl
	# rm $(base_tform_dir)/$(VSPHERE_VM_NAME)/terraform.tfstate
	# rm $(base_tform_dir)/$(VSPHERE_VM_NAME)/terraform.tfstate.backup
	mv $(base_tform_dir)/$(VSPHERE_VM_NAME)/main.tf ./
	sed -i 's/crunchy-iac/$(VSPHERE_VM_NAME)/g' main.tf
	mv main.tf $(base_tform_dir)/$(VSPHERE_VM_NAME)/main.tf

terraform_init_plan:
	terraform -chdir=$(base_tform_dir)/$(VSPHERE_VM_NAME) init
	terraform -chdir=$(base_tform_dir)/$(VSPHERE_VM_NAME) plan --var="vsphere_password=$(VSPHERE_PASSWORD)" --var="vsphere_vm_disk_size=$(VSPHERE_VM_DISK_SIZE)" --var="vsphere_vm_name=$(VSPHERE_VM_NAME)" --var="vsphere_vm_memory=$(VSPHERE_VM_MEMORY)" --var="vsphere_vm_cpus=$(VSPHERE_VM_CPUS)"

terraform_init_apply:
	terraform -chdir=$(base_tform_dir)/$(VSPHERE_VM_NAME) init
	terraform -chdir=$(base_tform_dir)/$(VSPHERE_VM_NAME) apply --var="vsphere_password=$(VSPHERE_PASSWORD)" --var="vsphere_vm_disk_size=$(VSPHERE_VM_DISK_SIZE)" --var="vsphere_vm_name=$(VSPHERE_VM_NAME)" --var="vsphere_vm_memory=$(VSPHERE_VM_MEMORY)" --var="vsphere_vm_cpus=$(VSPHERE_VM_CPUS)" --auto-approve

terraform_local_defaults:
	terraform -chdir=$(base_tform_dir)/$(VSPHERE_VM_NAME) init
	terraform -chdir=$(base_tform_dir)/$(VSPHERE_VM_NAME) apply --var="vsphere_password=$(VSPHERE_PASSWORD)" --var="vsphere_vm_name=$(VSPHERE_VM_NAME)" --auto-approve

terraform_plan: terraform_pre_clean terraform_copy terraform_init_plan
terraform_deploy: terraform_pre_clean terraform_copy terraform_init_apply git_checkout_push

terraform_local_deploy: terraform_pre_clean terraform_copy terraform_local_defaults
