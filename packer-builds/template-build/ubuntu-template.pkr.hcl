packer {
  required_version = ">= 1.8.0"
  required_plugins {
    vsphere = {
      version = ">= v1.0.3"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

locals {
  build_by      = "Built by: Hugo Tinoco ${packer.version}"
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version = formatdate("YY.MM", timestamp())
  manifest_date = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path = "${path.cwd}/packer-builds/manifests/"
  vm_template_name_local = "${var.vm_template_name}-${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-v${local.build_version}-${local.build_date}"
  data_source_content = {
    "/meta-data" = file("${abspath(path.root)}/data/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/data/user-data.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password_encrypted = var.build_password_encrypted
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
    })
  }
  data_source_command = var.common_data_source == "http" ? "ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"" : "ds=\"nocloud\""
}

//  BLOCK: source
//  Defines the builder configuration blocks.

source "vsphere-iso" "ubuntu-template" {

  // vCenter Server Endpoint Settings and Credentials
  vcenter_server      = var.vsphere_endpoint
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_cluster
  datastore  = var.vsphere_datastore
  folder     = var.vsphere_folder

  // Virtual Machine Settings
  guest_os_type        = var.vm_guest_os_type
  vm_name              = local.vm_template_name_local
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_sockets
  cpu_cores            = var.vm_cpu_cores
  CPU_hot_plug         = var.vm_cpu_hot_add
  RAM                  = var.vm_mem_size
  RAM_hot_plug         = var.vm_mem_hot_add
  cdrom_type           = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }
  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm_network_card
  }
  vm_version           = var.common_vm_version
  remove_cdrom         = var.common_remove_cdrom
  tools_upgrade_policy = var.common_tools_upgrade_policy
  notes                = "Version: v${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"

  // Removable Media Settings
  iso_paths    = ["[${var.common_iso_datastore}] ${var.iso_path}/${var.iso_file}"]
  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  http_content = var.common_data_source == "http" ? local.data_source_content : null
  cd_content   = var.common_data_source == "disk" ? local.data_source_content : null
  cd_label     = var.common_data_source == "disk" ? "cidata" : null

  // Boot and Provisioning Settings
  http_ip       = var.common_data_source == "http" ? var.common_http_ip : null
  http_port_min = var.common_data_source == "http" ? var.common_http_port_min : null
  http_port_max = var.common_data_source == "http" ? var.common_http_port_max : null
  boot_order    = var.vm_boot_order
  boot_wait     = var.vm_boot_wait
  boot_command = [
    "c",
    "linux /casper/vmlinuz \"ds=nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\" autoinstall quiet --- ",
    "<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
  ]

  ip_wait_timeout  = var.common_ip_wait_timeout
  shutdown_command = "echo '${var.build_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = var.common_shutdown_timeout

  // Communicator Settings and Credentials
  communicator           = "ssh"
  ssh_username           = var.build_username
  ssh_password           = var.build_password
  ssh_port               = var.communicator_port
  ssh_timeout            = var.communicator_timeout
  ssh_handshake_attempts = "100000"

  // Template and Content Library Settings
  convert_to_template = var.common_template_conversion
  # dynamic "content_library_destination" {
  #   for_each = var.common_content_library_name != null ? [1] : []
  #   content {
  #     library     = var.common_content_library_name
  #     description = "Version: v${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
  #     ovf         = var.common_content_library_ovf
  #     destroy     = var.common_content_library_destroy
  #     skip_import = var.common_content_library_skip_export
  #   }
  # }
}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {
  sources = ["source.vsphere-iso.ubuntu-template"]

  provisioner "shell" {
    execute_command = "echo '${var.build_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.build_username}",
    ]
    scripts           = ["${abspath(path.root)}/scripts/user.sh", "${abspath(path.root)}/scripts/cleanup-root.sh", "${abspath(path.root)}/scripts/iac.sh", "${abspath(path.root)}/scripts/ssh.sh", "${abspath(path.root)}/scripts/setup.sh", "${abspath(path.root)}/scripts/docker.sh", "${abspath(path.root)}/scripts/docker-compose.sh", "${abspath(path.root)}/scripts/python-utils.sh", ]
    expect_disconnect = true
  }
  # provisioner "ansible" {
  #   playbook_file = "${path.cwd}/ansible/main.yml"
  #   roles_path    = "${path.cwd}/ansible/roles"
  #   ansible_env_vars = [
  #     "ANSIBLE_CONFIG=${path.cwd}/ansible/ansible.cfg"
  #   ]
  #   extra_arguments = [
  #     "--extra-vars", "display_skipped_hosts=false",
  #     "--extra-vars", "BUILD_USERNAME=${var.build_username}",
  #     "--extra-vars", "BUILD_SECRET='${var.build_key}'",
  #     "--extra-vars", "ANSIBLE_USERNAME=${var.ansible_username}",
  #     "--extra-vars", "ANSIBLE_SECRET='${var.ansible_key}'",
  #   ]
  # }

  post-processor "manifest" {
    output     = "${local.manifest_path}${local.manifest_date}.json"
    strip_path = true
    strip_time = true
    custom_data = {
      ansible_username         = var.ansible_username
      build_username           = var.build_username
      build_date               = local.build_date
      build_version            = local.build_version
      common_vm_version        = var.common_vm_version
      vm_cpu_cores             = var.vm_cpu_cores
      vm_cpu_sockets           = var.vm_cpu_sockets
      vm_disk_size             = var.vm_disk_size
      vm_disk_thin_provisioned = var.vm_disk_thin_provisioned
      vm_firmware              = var.vm_firmware
      vm_guest_os_type         = var.vm_guest_os_type
      vm_mem_size              = var.vm_mem_size
      vm_network_card          = var.vm_network_card
      vsphere_cluster          = var.vsphere_cluster
      vsphere_datacenter       = var.vsphere_datacenter
      vsphere_datastore        = var.vsphere_datastore
      vsphere_endpoint         = var.vsphere_endpoint
      vsphere_folder           = var.vsphere_folder
      vsphere_iso_path         = "[${var.common_iso_datastore}] ${var.iso_path}/${var.iso_file}"
    }
  }
}