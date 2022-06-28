#!/bin/bash -ue

sudo useradd -G sudo -m htinoco
sudo chpasswd -e <<< 'htinoco:$6$PoKVLFtelyThmfC9$NLEjyW52ZB1fnfzUi4G1x2w7y6oDmgftAqUUFqR4Hkl10s2EojwlguAEBs55i8qaj8OCOZhp8nb5KGJuFGmQF0'

sudo mkdir -p /home/htinoco/.ssh
sudo chmod 700 /home/htinoco/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsbDDVfMnnURRZ9VjL/Hu/Pfqq7XRIjVP6qhQeWfvHKF7tvEO62tF9MMG8E0eTsVvO1cccwnsxrm3dp/4wHmWfSVAbHFtfNDB4FxmK0uHtZV+KiHHvNdkVLX44EhdTMhxRdFkfQflRCvK5YZ6wh8o3591+OO+ZBzkBWr4LWcMjuFZV8LFkimquWDkHe30Hqhk7uwmYLiQMIHTKnoSXIdnVwEXy4/nz/PDXYe1rxkKqkX1tljdPU6dtu4fsQXRjY3pXzzicRWmh1uZc/E3wqEURbn1IkmFF7pdqT29he5Ic5nI3gp0siI6Je6VpYZwEdVgkF2YG7GZlR0qCgc8LKbqtaOI7ZGIZ6hKrTzITWxWxigpiv01lOiZGfa9VdNohgLbfGD4PEF/7NIkogGd3j4gl5l0YZVK/2MBu5WZMDWCNZ6ssRDJ9Ok7WKrFWECv3eT7H2nDRsz9ed0y+MWzD7W2AdaVryHOOsGL8Yp+O/Toqug6U7xn5htJNcdx/EU2YjlE= htinoco@pop-os" | sudo tee -a /home/htinoco/.ssh/authorized_keys
sudo chmod 600 /home/htinoco/.ssh/authorized_keys
sudo chown -R htinoco:htinoco /home/htinoco/.ssh
sudo ssh-keygen -A
