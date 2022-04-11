#!/bin/bash -ue

# reset and disable the root password and disable root SSH access.
sudo passwd -d root
sudo passwd -l root
sudo sed -i 's/PermitRootLogin yes/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
