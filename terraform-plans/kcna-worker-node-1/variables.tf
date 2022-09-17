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
  default = "DEVPOP-DATASTORE"
}

variable "vsphere_cluster" {
  type = string
  default = "CrunchyCluster"
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
  default = "template-linux-ubuntu-22.04.1-v22.09-2022-09-17 15:45 UTC"
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