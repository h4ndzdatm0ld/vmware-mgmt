# Ansible Project: `VMWare Mgmt`

VMWare Management with Ansible

Personal project used to manage a local VMWare Workstation Pro instance.

## Requirements

- Ansible >= 2.9

**Collections:**

- "qsypoq.vmware_desktop"

---

## Project features

- [Roles](roles/README.md)
- [Modules](plugins/modules/README.md)
- [Filters](plugins/filters/README.md)

---

Ensure that the VMWARE API is running. Substitute the cert.pem and key.pem for yours.
Initial run will require -C flag to configure user/password.

```bash
vmrest -c workstationapi-cert.pem -k workstationapi-key.pem
```

## Structure

The current home setup involves a VMWare Workstation Pro running on the main workstation machine. There is a Ubuntu 21.01 Server Guest VM that's used as a template. (This is an env variable for machine id) and it's used to quickly build new Guest VM's with all the necessary tools to have an isolated environment ready for development. A mounted, shared folder that stores all the GIT repos is included in 'mnt/hgfz/Pyprogz'. The onboarding playing, `pb.onboard.yml` ensures it's mounted correctly. Also, all the networking is statically assigned after coming up via DHCP, using `netplan`.

This has become very helpful for development of Django that take up multiple ports tied to any given machine and allows me to quickly change from one env to the other without having to shutdown and rebuild to free up ports and IP's when loading Django apps, as well as having a simple DNS entry to quickly access the projects.

The next steps:

- TODO: Add instance into Nautobot.

## Examples

The goal of this project was to have a quick way to create a simple VM from a local template. The local template is referenced by the ID of the Virtual Machine. This is specified via env variable, `VM_ID`.

The name of the new VM to create can also be overridden by extra-vars while invoking the playbook.
To run the playbook within a docker container:

```bash
docker-compose build && docker-compose run cli pb.clone-vm.yml -e cloned_vm_name="name of new cloned vm"
```

Env variables which are required for cloning a VM:

```bash
export WORKSTATION_URL=... [API URL]
export WORKSTRATION_USERNAME=...
export WORKSTRATION_PASSWORD=...
export WORKSTRATION_PORT=...
export WORKSTATION_VALIDATE_CERTS=...
export CLONED_VM_NAME=... [NAME OF THE NEW VM]
export VM_ID=... [VM ID BEING USED AS TEMPLATE TO CLONE FROM]
export WORKSTATION_PROJECT_DIR=... [PATH TO WHERE VM SHOULD BE STORED]
export ansible_password=... [STANDARD ANSIBLE]
export ansible_user=...[STANDARD ANSIBLE]
```

`WORKSTATION_PROJECT_DIR` must match the default location for Virtual Machines
![VM Location](docs/default_location.png)

## Testing

For testing guidelines explanation see [Testing](tests/README.md)

---

## Development and Contribution Guidelines

It is a standard Ansible Project. So best practices are found [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html).

Steps:

### Test project

After creation/modifications of roles, playbooks, or other modules are done, build and install the collection locally.

```shell
invoke build
invoke local-install
```
