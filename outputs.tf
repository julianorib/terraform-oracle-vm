output "instance" {
  value = oci_core_instance.vm.*.public_ip
}