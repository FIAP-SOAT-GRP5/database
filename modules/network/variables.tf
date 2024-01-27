variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "The IPv4 CIDR block for the subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags for network"
  type        = map(any)
}

variable "subnet_count" {
  description = "Count for subnets in VPC"
  type        = number
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false"
}

variable "securiry_group_name" {
  description = "Name of the security group. If omitted, Terraform will assign a random, unique name."
  type        = string
}

variable "from_db_port" {
  description = "Start port (or ICMP type number if protocol is icmp or icmpv6"
  type        = string
}

variable "to_db_port" {
  description = " End range port (or ICMP code if protocol is icmp)"
  type        = string
}