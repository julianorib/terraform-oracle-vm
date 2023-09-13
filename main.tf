terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.114.0"
    }
  }
}

resource "oci_identity_compartment" "oci" {
  name          = var.name
  description   = var.name
  enable_delete = true
}

data "oci_identity_availability_domains" "AD" {
  compartment_id = oci_identity_compartment.oci.id
}

resource "oci_core_vcn" "vcn" {
  compartment_id = oci_identity_compartment.oci.id
  cidr_block     = "10.0.0.0/16"
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = oci_identity_compartment.oci.id
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "route" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_default_security_list" "sec" {
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "subnet" {
  compartment_id    = oci_identity_compartment.oci.id
  cidr_block        = "10.0.0.0/24"
  vcn_id            = oci_core_vcn.vcn.id
  route_table_id    = oci_core_default_route_table.route.id
  security_list_ids = [oci_core_default_security_list.sec.id]
}

data "oci_core_images" "os" {
  compartment_id           = oci_identity_compartment.oci.id
  shape                    = var.shape
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
}

resource "oci_core_instance" "vm" {
  count               = var.nodes
  display_name        = "node-${count.index}"
  availability_domain = data.oci_identity_availability_domains.AD.availability_domains[var.availability_domain].name
  compartment_id      = oci_identity_compartment.oci.id
  shape               = var.shape
  shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }
  source_details {
    source_id   = data.oci_core_images.os.images[0].id
    source_type = "image"
  }
  create_vnic_details {
    subnet_id  = oci_core_subnet.subnet.id
    private_ip = "10.0.0.1${count.index}"
  }
  metadata = {
    ssh_authorized_keys = file(var.sshkey)
  }
}

