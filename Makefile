SHELL := /bin/bash
.PHONY: all_ubuntu

base_ubuntu_dir = ./packer-builds/template-build
ubuntu_vars = $(base_ubuntu_dir)/variables.pkr.hcl

# Ubuntu Build
# Base image to feed into ubuntu jobs
ubuntu_base:
	PACKER_LOG=1
	packer build -force -var "vsphere_password=$(VMWARE_PASSWORD)" $(base_ubuntu_dir)
