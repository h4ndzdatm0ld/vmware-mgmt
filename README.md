# Ansible Project: `VMWare Mgmt`

VMWare Management with Ansible

## Requirements

- Ansible >= 2.9


**Collections:**


**Roles:**
- `ansible-network.network-engine`

---

## Project features


- [Roles](roles/README.md)
- [Modules](plugins/modules/README.md)
- [Filters](plugins/filters/README.md)

---

## Examples

TBD

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

Perform tests locally before commiting and generating a PR for review.
# vmware-mgmt
