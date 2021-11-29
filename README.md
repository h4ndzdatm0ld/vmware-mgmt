# Ansible Project: `VMWare Mgmt`

VMWare Management with Ansible

Personal project used to manage a local  VMWare Workstation Pro instance.

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

## Examples

The goal of this project was to have a quick way to create a simple VM from a local template. The local template is referenced by the ID of the Virtual Machine. This is specified via env variable, `VM_ID`.

A value that is hardcoded, is the path for the folder directory. This could be later on re-evaluated if needed to be re-used.

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
export ansible_password=... [STANDARD ANSIBLE]
export ansible_user=...[STANDARD ANSIBLE]
```

---

## Testing

For testing guidelines see explanation see [Testing](tests/README.md)

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

Perform tests locally before committing and generating a PR for review.
# vmware-mgmt
