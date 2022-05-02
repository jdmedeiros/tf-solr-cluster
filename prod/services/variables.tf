variable "key_name" {
  type = string
  default = "vockey"
}

variable "volume_size" {
  type = number
  default = 30
}

variable "security_group_name" {
  type = string
  default = "Solr and Zookeeper security group"
}

variable "cloud_config-zookeeper" {
  type = string
  default = "cloud-config-zookeeper.sh"
}

variable "cloud_config-solr" {
  type = string
  default = "cloud-config-solr.sh"
}

variable "fw_rules" {
  description = "Firewall rules"
  #                  Protocol [-1 for all traffic]
  #                  |       From port [0 for all ports]
  #                  |       |       To port [0 for all ports]
  #                  |       |       |       Description
  #                  |       |       |       |       Link to ip_list entry
  #                  |       |       |       |       |
  type = list(tuple([string, number, number, string, number]))
  default = [
    [-1, 0, 0, "Allow all traffic", 0],
  ]
}

variable "ip_list" {
  description = "Allowed IPs"
  type = list(list(string))
  default = [
    ["128.65.243.205/32", "78.29.147.32", "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"],
  ]
}

variable "solr_instance_ami" {
  default = "ami-0f9fc25dd2506cf6d"
}

variable "solr_instance_names" {
  default = [ "solr1", "solr2", "solr3" ]
}

variable "solr_private_ips" {
  default = [ "172.16.0.11", "172.16.0.12", "172.16.0.13" ]
}

variable "zookeeper_instance_names" {
  default = [ "zookeeper1", "zookeeper2", "zookeeper3" ]
}

variable "zookeeper_private_ips" {
  default = [ "172.16.0.21", "172.16.0.22", "172.16.0.23" ]
}

variable "zookeeper_myids" {
  default = [ "zookeeper/myid1", "zookeeper/myid2", "zookeeper/myid3" ]
}

variable "zookeeper_instance_ami" {
  default = "ami-0f9fc25dd2506cf6d"
}
