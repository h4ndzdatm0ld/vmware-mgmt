"""Tasks for use with Invoke."""
from invoke import task


@task
def yamllint(context):
    """Run yamllint to validate formatting adheres to NTC YAML standards."""
    exec_cmd = "yamllint ."
    context.run(exec_cmd)


@task
def ansiblelint(context):
    """Run Ansible-Lint."""
    exec_cmd = "ansible-lint playbooks/*"
    context.run(exec_cmd)


@task
def tests(context):
    """Run all tests for this repository."""
    print("Running Ansible Lint")
    ansiblelint(context)
    print("Running yamllint")
    yamllint(context)
    print("yamllint succeeded")

    print("All tests have passed!")
