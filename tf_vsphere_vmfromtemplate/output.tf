output "avi_controller_ip" {
  value = vsphere_virtual_machine.avicontroller-vm.default_ip_address
  description = "IP assigned to controller"
}