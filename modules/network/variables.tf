##### VPC 생성 #####
variable "vpc_cidr" {
description = "VPC"
  type = string
  default = "10.16.0.0/16"
}
variable "instance_tenancy" {
  description = "Instance Tenancy"
  type = string
  default = "default"
}

### Subnet ###
### public subnet ###
variable "pub_sub1_cidr" {
  description = "Pub_Sub1 CIDR Block"
  type = string
  default = "10.16.2.0/24"
}
### zone ### 
variable "zone_1" {
  description = "value"
  type = string
  default = "us-east-1a"
}
### private-subnet ###
variable "pri_sub1_cidr" {
  description = "Pri_Sub1 CIDR Block"
  type = string
  default = "10.16.3.0/24"
}

variable "destination_cidr_block" {
  description = "Destination_cidr_block"
  type = string
  default = "0.0.0.0/0"
}
### bation host ### 
variable "ec2_tags" {
  description = "Internet Gateway tags"
  type = map(string)
  default = { Name = "bastion-host" }
}
variable "environment" {
  description = "environment"
  type = string
}