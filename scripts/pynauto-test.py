"""Place to test PYNAUTOBOT."""
import os

from pynautobot import api

url = os.environ["NAUTOBOT_URL"]
token = os.environ["NAUTOBOT_TOKEN"]

nautobot = api(url=url, token=token)
nautobot.http_session.verify = False

device_roles = nautobot.dcim.device_roles
# Create a dict of keyword arguments to use for device role config.
access_role_config = {
    "name": "Access Switch",
    "slug": "access-switch",
}

# Create a new Record in the Device Roles Model.
access_role = device_roles.create(**access_role_config)
