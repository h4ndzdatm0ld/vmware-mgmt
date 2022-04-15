/*
    DESCRIPTION:
    Ubuntu Server 21.10 LTS  variables used by the Packer Plugin for VMware vSphere (vsphere-iso).
*/

// Guest Operating System Metadata
vm_guest_os_family  = "linux"
vm_guest_os_name    = "ubuntu"
vm_guest_os_version = "21.10"

// Virtual Machine Guest Operating System Setting
vm_guest_os_type = "ubuntu64Guest"

// Virtual Machine Hardware Settings
vm_firmware              = "bios"
vm_cdrom_type            = "sata"
vm_cpu_sockets           = 6
vm_cpu_cores             = 1
vm_cpu_hot_add           = false
vm_mem_size              = 6144
vm_mem_hot_add           = false
vm_disk_size             = 50960
vm_disk_controller_type  = ["pvscsi"]
vm_disk_thin_provisioned = true
vm_network_card          = "vmxnet3"

// Removable Media Settings
iso_path           = "ISOs/"
iso_file           = "ubuntu-21.10-live-server-amd64.iso"
iso_checksum_type  = "sha256"
iso_checksum_value = "e84f546dfc6743f24e8b1e15db9cc2d2c698ec57d9adfb852971772d1ce692d4"


// Boot Settings
vm_boot_order = "disk,cdrom"
vm_boot_wait  = "5s"

// Communicator Settings
communicator_port        = 22
communicator_timeout     = "30m"
common_ip_wait_timeout   = "30m"
build_username           = "ubuntu"
build_password           = "ubuntu"
build_key                = "/some/key"
build_password_encrypted = "$6$rounds=4096$TXOY/GL/Bho73z4x$q0Zjz5rmBdR5pLkkSmq.eIRS9UIZLUiVHY2sFKXDy4O.VhGuo./rpBNjFs6JRoc5hw3u9vGZ1yPht3ACYYJks/"
ansible_key              = "/some/key"
ansible_username         = "ubuntu"

// Boot and Provisioning Settings
common_data_source      = "http"
common_http_ip          = null
common_http_port_min    = 8000
common_http_port_max    = 8099
common_shutdown_timeout = "15m"
common_remove_cdrom     = true
data_source_content     = "http"

// vcenter
vsphere_cluster             = "HeshLawCluster"
vsphere_endpoint            = "vcenter.heshlaw.local"
vsphere_username            = "administrator@heshlaw.local"
vsphere_insecure_connection = true
