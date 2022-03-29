SHELL = /bin/bash
.PHONY: all_ubuntu

base_ubuntu_dir = ./packer-build/template-build
ubuntu_vars = $(base_ubuntu_dir)/variables.pkr.hcl

# Ubuntu Build
# Base image to feed into ubuntu jobs
ubuntu_base:
	-rm -fr packer-build/output/*.iso
	packer build $(base_ubuntu_dir)
