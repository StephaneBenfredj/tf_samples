# vsphere provider
#
# Create Avi controller in vCenter using an existing template in Content Library


terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "= 1.24.3"
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
