#!/bin/bash

mkdir ~/.ssh/
cd ~/.ssh/
ssh-keygen -t rsa -f id_rsa -q -P ""
ssh-keygen -A
systemctl restart sshd

# remove host keys
sudo rm -f /etc/ssh/ssh_host_*
