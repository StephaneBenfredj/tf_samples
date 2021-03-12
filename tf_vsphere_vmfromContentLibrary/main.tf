# vsphere provider
#
# Create Avi controller in vCenter using an existing template in Content Library


terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "= 1.24.3"
    }
    avi = {
      source = "vmware/avi"
      version = "20.1.4"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_dc
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resources
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# use an existing folder, otherwise need to create a folder ressource
data "vsphere_folder" "folder" {
  path          = var.vsphere_folder
  # type          = "vm"
  # datacenter_id = data.vsphere_datacenter.dc.id
}

# grabbing ID of the content library
data "vsphere_content_library" "library" {
  name = "AVI_Images"
}

# grabbing ID of the content library template 
data "vsphere_content_library_item" "image" {
  name       = var.avi_controller_image
  library_id = data.vsphere_content_library.library.id
  type       = "vm-template" 
}

resource "vsphere_virtual_machine" "avicontroller-vm" {
  name             = var.avi_controller_name
  # datacenter_id    = data.vsphere_datacenter.dc.id # this one is only used when deploying from OVF
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  # datastore_cluster_id = data.vsphere_compute_cluster.compute_cluster.id
  #
  folder           = data.vsphere_folder.folder.path
  num_cpus = var.avi_controller_cpus
  memory   = var.avi_controller_mem
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"  # from provider's doc - It's recommended that you set the disk label to a format matching diskN, where N is the number of the disk, starting from disk number 0
    size  = var.avi_controller_disk
  }

  wait_for_guest_net_timeout = 3
  # wait_for_guest_ip_timeout
  
  clone {
    template_uuid = data.vsphere_content_library_item.image.id
  }

  # vapp {
  #   properties = {
  #     "mgmt-ip"     = 
  #     "mgmt-mask"   = 
  #     "default-gw"  = 
  #  }
 }


provider "avi" {
  avi_username   = var.avi_username
  avi_password   = var.avi_new_password
  avi_controller = vsphere_virtual_machine.avicontroller-vm.default_ip_address
  avi_tenant     = "admin"
  avi_version    = var.avi_version
}

provider "avi" {
  alias = "temp"
  avi_username   = var.avi_username
  avi_password   = var.avi_initial_password
  avi_controller = vsphere_virtual_machine.avicontroller-vm.default_ip_address
  avi_tenant     = "admin"
  avi_version    = var.avi_version
}

resource "avi_useraccount" "avi_user" {
  provider = avi.temp
  username     = var.avi_username
  old_password = var.avi_initial_password
  password     = var.avi_new_password
}

resource "avi_backupconfiguration" "avi_backup_config" {
  depends_on = [
    avi_useraccount.avi_user,
  ]
  provider = avi  # should not be needed - default 
  name = "Backup-Configuration"
  save_local = true
  backup_passphrase = var.avi_backup_passphrase
}

resource "avi_systemconfiguration" "avi_system_config" {
  depends_on = [
    avi_useraccount.avi_user,
  ]
  provider = avi # should not be needed - default
  dns_configuration {
    search_domain = ""
    server_list {
        type = "V4"
        addr = "10.206.8.130"
    }
  }
  # ntp_configuration {  #DOES NOT WORK
  #  ntp_server_list {
  #    type = "DNS"
  #    addr = "10.170.16.48"
  #  }
  # }
  
  welcome_workflow_complete = true
}


##NEED TO ADD LOGIC FOR SLEEP
#

#terraform {
#  required_providers {
#    time = {
#      source = "hashicorp/time"
#      version = "0.7.0"
#    }
#  }
#}