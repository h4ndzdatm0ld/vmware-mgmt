# VMWare Mgmt

VMWare Management with Ansible, Packer and Terraform

A personal project used to manage my local VMWare Workstation Pro & ESXI/vSphere instances. The majority of the documentation here is specific to my home network. All of these jobs are executed by Rundeck.

## Requirements

- Docker
- Docker-Compose
- Packer
- Terraform

---

## General

There will be a mounted volume on the docker container used to execute the variety of playbooks available. This simplifies the ability to write, test and customize playbooks with a built Docker image.

The project uses both community `vmware.vmware_rest` and `community.vmware.vmware_guest` collections for the ansible playbooks, as well as the VMWare Workstation Pro `qsypoq.vmware_desktop` collection.

## Network Playbooks

The `pb.edgeos-update.yml` playbook is essentially only to create a static DNS entry in the local router EdgeOS router of my network. This PB connects to the edge-router and loops through a specified group and sets the `inventory_hostname` + `ansible_host` magic variable as a static entry.

## vSphere Playbooks

The local env has an ESXI Server with vSphere provisioned.

## Packer Build

Call the MAKE target to execute the packer build while exporting the `VSPHERE_PASSWORD`

```bash
make ubuntu_base VSPHERE_PASSWORD=SomePassword
```

## Terraform

First, you must create the workspace in Terraform Cloud and set it to `Local` execution. Without this, you will receive errors as the execution will happen in terraform cloud.

Run the `terraform_plan` make target

If everything looks good, and you want to deploy, execute `terraform_deploy`

## Example Env Variables

There is an example file inside the docs folder of the repository at `docs/example-env.txt`.

```bash
export ansible_password=... [STANDARD ANSIBLE]
export ansible_user=...[STANDARD ANSIBLE]
```
