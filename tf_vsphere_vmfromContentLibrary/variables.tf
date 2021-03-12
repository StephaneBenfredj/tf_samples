variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "vsphere_dc" {}
variable "vsphere_cluster" {}
variable "vsphere_datastore" {}
variable "vsphere_resources" {}
variable "vsphere_network" {}

variable "vsphere_folder" {
    default = "Stephane"
}
#
variable avi_controller_cpus {
    default = 8
}

variable avi_controller_mem {
    default = 24768
}

variable avi_controller_disk {
    default = 128
}

variable avi_controller_image {}
variable avi_controller_name {}
variable avi_controller_vm_template {}

variable avi_username {
    default = "admin"
}

variable avi_initial_password {}
variable avi_new_password {}

variable avi_version {}

variable avi_backup_passphrase {}
