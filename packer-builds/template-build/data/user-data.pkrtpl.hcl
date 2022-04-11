#cloud-config
autoinstall:
    version: 1
    apt:
        geoip: true
        preserve_sources_list: false
        primary:
            - arches: [amd64, i386]
              uri: http://us.archive.ubuntu.com/ubuntu
            - arches: [default]
              uri: http://ports.ubuntu.com/ubuntu-ports
    early-commands:
        - sudo systemctl stop ssh
    locale: ${vm_guest_os_language}
    keyboard:
        layout: ${vm_guest_os_keyboard}
    identity:
        hostname: ubuntu-server
        username: ${build_username}
        password: ${build_password_encrypted}
    ssh:
        install-server: true
        allow-pw: true
    users:
      - default
      - name: htinoco
        passwd: "$6$PoKVLFtelyThmfC9$NLEjyW52ZB1fnfzUi4G1x2w7y6oDmgftAqUUFqR4Hkl10s2EojwlguAEBs55i8qaj8OCOZhp8nb5KGJuFGmQF0"
        hashed_passwd: "$6$PoKVLFtelyThmfC9$NLEjyW52ZB1fnfzUi4G1x2w7y6oDmgftAqUUFqR4Hkl10s2EojwlguAEBs55i8qaj8OCOZhp8nb5KGJuFGmQF0"
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: sudo
        lock_passwd: true
        ssh_pwauth: True
        ssh_import_id: None
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsbDDVfMnnURRZ9VjL/Hu/Pfqq7XRIjVP6qhQeWfvHKF7tvEO62tF9MMG8E0eTsVvO1cccwnsxrm3dp/4wHmWfSVAbHFtfNDB4FxmK0uHtZV+KiHHvNdkVLX44EhdTMhxRdFkfQflRCvK5YZ6wh8o3591+OO+ZBzkBWr4LWcMjuFZV8LFkimquWDkHe30Hqhk7uwmYLiQMIHTKnoSXIdnVwEXy4/nz/PDXYe1rxkKqkX1tljdPU6dtu4fsQXRjY3pXzzicRWmh1uZc/E3wqEURbn1IkmFF7pdqT29he5Ic5nI3gp0siI6Je6VpYZwEdVgkF2YG7GZlR0qCgc8LKbqtaOI7ZGIZ6hKrTzITWxWxigpiv01lOiZGfa9VdNohgLbfGD4PEF/7NIkogGd3j4gl5l0YZVK/2MBu5WZMDWCNZ6ssRDJ9Ok7WKrFWECv3eT7H2nDRsz9ed0y+MWzD7W2AdaVryHOOsGL8Yp+O/Toqug6U7xn5htJNcdx/EU2YjlE= htinoco@pop-os
      - name: ubuntu
        lock_passwd: false
        hashed_passwd: "$6$4I6Y4My9EZtF1fgH$zrwbjdumNdr78Ie8E2Ok7V.KxerZ1DjmFhQska2LqzooNTrnSW45x3cQlWoJBGMcsYPEB8wjieTNibu4kFpKp/"
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsbDDVfMnnURRZ9VjL/Hu/Pfqq7XRIjVP6qhQeWfvHKF7tvEO62tF9MMG8E0eTsVvO1cccwnsxrm3dp/4wHmWfSVAbHFtfNDB4FxmK0uHtZV+KiHHvNdkVLX44EhdTMhxRdFkfQflRCvK5YZ6wh8o3591+OO+ZBzkBWr4LWcMjuFZV8LFkimquWDkHe30Hqhk7uwmYLiQMIHTKnoSXIdnVwEXy4/nz/PDXYe1rxkKqkX1tljdPU6dtu4fsQXRjY3pXzzicRWmh1uZc/E3wqEURbn1IkmFF7pdqT29he5Ic5nI3gp0siI6Je6VpYZwEdVgkF2YG7GZlR0qCgc8LKbqtaOI7ZGIZ6hKrTzITWxWxigpiv01lOiZGfa9VdNohgLbfGD4PEF/7NIkogGd3j4gl5l0YZVK/2MBu5WZMDWCNZ6ssRDJ9Ok7WKrFWECv3eT7H2nDRsz9ed0y+MWzD7W2AdaVryHOOsGL8Yp+O/Toqug6U7xn5htJNcdx/EU2YjlE= htinoco@pop-os
    packages:
        - software-properties-common
        - gnupg
        - cloud-init
        - curl
        - net-tools
        - open-vm-tools
        - netplan.io
        - needrestart
        - resolvconf
        - open-vm-tools-desktop
        - fuse
        - net-tools
        - network-manager
        - nfs-common
        - nfs-kernel-server
        - rsync
        - tree
        - git
    storage:
        layout:
            name: direct
    user-data:
        disable_root: true
        package_update: true
        package_upgrade: true
        package_reboot_if_required: true
        timezone: ${vm_guest_os_timezone}
    late-commands:
        - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
        - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
        - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}
        - curtin in-target --target=/target -- apt-get update
        - curtin in-target --target=/target -- apt-get upgrade --yes
