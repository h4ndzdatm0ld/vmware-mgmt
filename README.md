# VMWare Mgmt

VMWare Management with Ansible, Packer and Terraform

A personal project used to manage my local VMWare Workstation Pro & ESXI/vSphere instances. The majority of the documentation here is specific to my home network. All of these jobs are executed by Rundeck.

## Requirements

- Docker
- Docker-Compose

---

## General

There will be a mounted volume on the docker container used to execute the variety of playbooks available. This simplifies the ability to write, test and customize playbooks with a built Docker image.

The project uses both community `vmware.vmware_rest` and `community.vmware.vmware_guest` collections for the ansible playbooks, as well as the VMWare Workstation Pro `qsypoq.vmware_desktop` collection.

## Network Playbooks

The `pb.edgeos-update.yml` playbook is essentially only to create a static DNS entry in the local router EdgeOS router of my network. This PB connects to the edge-router and loops through a specified group and sets the `inventory_hostname` + `ansible_host` magic variable as a static entry.

## vSphere Playbooks

The local env has an ESXI Server with vSphere provisioned.

### Deploying a new template

Our SoT is our inventory file at the moment. Create a new entry under the `servers_esxi` group. It must include a hostname and `ansible_host` ip address. These values are required in the playbook.

Example:

```
docker-compose run cli playbooks/vsphere/pb.deploy-vm.yml -e cloned_vm_name="cloned_vm_name"
```

Variables that must be defined and can be overridden with `extra_vars`

- cloned_vm_name: "VM Name"
- datacenter: "CrunchyDatacenter"
- folder: "Nautobot Plugins"
- template: "Ubuntu-Template"

After the playbook has been deployed, run the `common` playbook, `pb.onboard.yml` to update all the necessary items.

## Packer Build

Export the password for vSphere

```bash
export VSPHERE_PASSWORD=....
```

Call the MAKE target to execute the packer build

```bash
make ubuntu_base
```

## Terraform

First, you must create the workspace in Terraform Cloud and set it to `Local` execution. Without this, you will receive errors as the execution will happen in terraform cloud.

Run the `terraform_plan` make target

If everything looks good, and you want to deploy, execute `terraform_deploy`

## vMware Workstation Pro Playbooks - DEPRECATED

Ensure that the VMWARE API is running.

The initial run will require -C flag to configure user/password.

```bash
vmrest -c workstationapi-cert.pem -k workstationapi-key.pem
```

### Examples

The goal of this project is to have a quick way to create a simple VM from a local template. The local template is referenced by the ID of the Virtual Machine. This is specified via the env variable, `VM_ID`.

The name of the new VM to create can also be overridden by extra-vars while invoking the playbook. To run the playbook within a docker container:

```bash
docker-compose build && docker-compose run cli pb.clone-vm.yml -e cloned_vm_name="name of new cloned vm"
```

## Example Env Variables

There is an example file inside the docs folder of the repository at `docs/example-env.txt`.

```bash
export ansible_password=... [STANDARD ANSIBLE]
export ansible_user=...[STANDARD ANSIBLE]
```

`WORKSTATION_PROJECT_DIR` must match the default location for Virtual Machines in Workstation Env. ![VM Location](docs/default_location.png)
