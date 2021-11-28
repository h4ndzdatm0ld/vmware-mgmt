#  pylint: disable=invalid-name
# """Ansible Lint Example."""
# # Copyright (c) 2016, Will Thames and contributors
# # Copyright (c) 2018, Ansible Project

# from ansiblelint import AnsibleLintRule


# class CapitalNamesRule(AnsibleLintRule):
#     id = "289"
#     shortdesc = "All task names should be capitalized"
#     description = "Capital names creates uniformity and improves readability"
#     severity = "LOW"
#     tags = ["formatting", "readability"]
#     version_added = "v4.0.0"

#     def matchtask(self, file, task):  # pylint: disable=unused-argument
#         if task.get("name"):
#             return task.get("name") != task.get("name").upper()
