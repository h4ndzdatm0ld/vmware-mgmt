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
    packages:
        - cloud-init
        - curl
        - net-tools
        - open-vm-tools
        - openssh-server
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
    storage:
        layout:
            name: direct
    user-data:
        disable_root: false
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
