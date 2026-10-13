resource "ibm_is_vpc" "journey" {
  resource_group = data.ibm_resource_group.group.id
  name           = "journey-vpc"
}

resource "ibm_is_subnet" "journey-subnet" {
  resource_group  = data.ibm_resource_group.group.id
  name            = "journey-subnet"
  vpc             = ibm_is_vpc.journey.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
  network_acl     = ibm_is_network_acl.allow-ssh.id
}

resource "ibm_is_instance" "journey-vsi" {
  resource_group = data.ibm_resource_group.group.id
  name           = "journey-vsi01"
  image          = var.system-image
  profile        = var.profile
  tags           = ["demo"]

  primary_network_interface {
    subnet          = ibm_is_subnet.journey-subnet.id
    security_groups = [ibm_is_security_group.journey_security_group.id]
    primary_ip {
      auto_delete = true
    }
    allow_ip_spoofing = true
  }

  vpc  = ibm_is_vpc.journey.id
  zone = ibm_is_subnet.journey-subnet.zone
  keys = [data.ibm_is_ssh_key.journey-ssh-key.id]


  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_is_network_acl" "allow-ssh" {
  resource_group = data.ibm_resource_group.group.id
  vpc            = ibm_is_vpc.journey.id
  name           = "allow-ssh"
  rules {
    name        = "inbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
    tcp {
      port_max = 22
      port_min = 22
    }
  }
  rules {
    name        = "outbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    tcp {
      port_min = 1
      port_max = 65535
    }
  }
}

resource "ibm_is_security_group" "journey_security_group" {
  name           = "journey-security-group"
  vpc            = ibm_is_vpc.journey.id
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group_rule" "ssh_in" {
  group     = ibm_is_security_group.journey_security_group.id
  direction = "inbound"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "icmp_in" {
  group     = ibm_is_security_group.journey_security_group.id
  direction = "inbound"
  icmp {
    type = 8
  }
}

resource "ibm_is_floating_ip" "journey-fip" {
  name           = "journey-floating-ip"
  target         = ibm_is_instance.journey-vsi.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.group.id
}
