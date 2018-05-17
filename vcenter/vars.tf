variable "viuser" {default = "sa_vcenter_prov@dirtybit.io"}
variable "vipassword" {default = "3todkE&o&C7J^t0"}
variable "viserver" {
  default = "db-vc-p01.dirtybit.io"
}

// default VM name in vSphere
variable "vmname" {
  default = "test-vm"
}

// default VM hostname
variable "vmhostname" {
  default = "db-esx-p03.dirtybit.io"
}

// default Resource Pool
variable "vmrp" {
  default = "terraform"
}

// default VM domain for guest customization
variable "vmdomain" {
  default = "dirtybit.io"
}

// default datastore to deploy vmdk
variable "vmdatastore" {
  default = "vsanDatastore"
}

// default VM Template
variable "vmtemp" {
  default = "w2k16_template"
}

// default disksize
variable "disksize" {
  default = "100"
}

// map of the datastore clusters (vmdatastore = "vmdscluster")
variable "vmdscluster" {
  type = "map"
  default = {
    DS_SILVER_01 = "DS_CLUSTER_SILVER"
    DS_SILVER_02 = "DS_CLUSTER_SILVER"
    DS_GOLD_01 = "DS_CLUSTER_GOLD"
    DS_GOLD_02 = "DS_CLUSTER_GOLD"
  }
}

// map of the compute clusters (vmrp = "vmcluster")
variable vmcluster {
  type = "map"
  default = {
    terraform = "Test"
    ANOTHER_RP = "RESOURCE_01_CLUSTER_GOLD"
    THIRD_RP = "RESOURCE_CLUSTER_SILVER"
  }
}

// map of the first three octets of the IP address (with netmask /24, vmdomain = "vmaddrbase")
variable "vmaddrbase" {
  type = "map"
  default = {
    dirtybit.io = "10.14.2."
    second.domain = "192.168.1."
  }
}

// host octet in the IP address
variable "vmaddroctet" {
  default = "200"
}

// map of the IP gateways (vmdomain = "vmgateway")
variable "vmgateway" {
  type = "map"
  default = {
    dirtybit.io = "10.14.2.1"
    second.domain = "192.168.1.1"
  }
}

// map of the DNS1 addresses (vmdomain = "vmdns1")
variable "vmdns1" {
  type = "map"
  default = {
    dirtybit.io = "10.14.2.10"
    second.domain = "192.168.1.5"
  }
}

// map of the DNS2 addresses (vmdomain = "vmdns2")
variable "vmdns2" {
  type = "map"
  default = {
    local.domain = "192.168.0.6"
    second.domain = "192.168.1.6"
  }
}

// map of the VM Network (vmdomain = "vmnetlabel")
variable "vmnetlabel" {
  type = "map"
  default = {
    dirtybit.io = "app_p"
  }
}
