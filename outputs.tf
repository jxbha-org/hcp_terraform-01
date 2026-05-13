output "resource_group" {
  value = data.ibm_resource_group.group
}

output "public_ip" {
  value = ibm_is_floating_ip.journey-fip.address
}