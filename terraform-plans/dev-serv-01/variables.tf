# vSphere Credentials

variable "vsphere_user" {
  type = string
  default = "administrator@heshlaw.local"
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
  default = "vcenter.heshlaw.local"
}

## vSphere Infra

variable "vsphere_datastore" {
  type = string
  // default = "Crunchy"
  default = "DEVPOP-DATASTORE-SSD-980"
}

variable "vsphere_cluster" {
  type = string
  default = "HeshLawCluster"
}

variable "vsphere_network" {
  type = string
  // default = "CrunchyMgmt"
  default = "VM Network"
}

variable "vsphere_datacenter" {
  type = string
  default = "CrunchyDataCenter"
}

variable "vsphere_vm_name" {
  type = string
  default = "crunchy-vm-tf"
}


## VM Vars

variable "vsphere_vm_template" {
  type = string
  default = "template-linux-ubuntu-21.10-v22.04-2022-04-26 17:03 UTC"
}

variable "vsphere_vm_guest_id" {
  type = string
  default = "ubuntu64Guest"
}

variable "vsphere_vm_cpus" {
  type = number
  default = 4
}

variable "vsphere_vm_memory" {
  type = number
  default = 4096
}

variable "vsphere_vm_disk_size" {
  type = number
  default = 50
}