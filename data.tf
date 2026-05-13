data "ibm_is_ssh_key" "journey-ssh-key" {
  id = var.ibm_ssh_key
}

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}
