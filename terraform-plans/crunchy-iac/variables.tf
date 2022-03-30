variable "vsphere_user" {
  type = str
  default = "root"
}

variable "vsphere_password" {
  type = str
  default = "root"
}

variable "vsphere_server" {
  type = str
  default = "crunchy-vsphere.local"
}

variable "vm_name" {
  type = str
  default = "crunchy-vm"
}
