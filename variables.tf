# common variables
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

# cluster variables
## ECR
variable "ecr_url" {
  description = "ecr_url"
  type = string
}
variable "ecr_arn" {
  description = "ecr_arn"
  type = string
}

## ECS
variable "log_group" {
  description = "cloudwatch log group ID"
  type = string 
}
variable "log_stream" {
  description = "cloudwatch log stream ID"
  type = string 
}
variable "namespace" {
  description = "namespace"
  type = string
}
variable "environment" {
  description = "environment"
  type = string
}
variable "instance_type" {
  description = "cluster name"
  type = string
}
variable "maximum_scaling_step_size" {
  description = "Maximum scaling step size"
  type        = number
  default     = 1
}
variable "minimum_scaling_step_size" {
  description = "Minimum scaling step size"
  type        = number
  default     = 1
}
variable "target_capacity" {
  description = "Target capacity"
  type        = number
  default     = 1
}
variable "ecs_task_max_count" {
  description = "ECS task max count"
  type        = number
  default     = 1
}
variable "ecs_task_min_count" {
  description = "ECS task min count"
  type        = number
  default     = 1
}
variable "ecs_task_desired_count" {
  description = "ECS task desired count"
  type        = number
  default     = 1
}
variable "cpu_target_tracking_desired_value" {
  description = "ECS task CPU"
  type        = number
  default     = 256
}
variable "memory_target_tracking_desired_value" {
  description = "ECS task memory"
  type        = number
  default     = 512
}
variable "autoscaling_max_size" {
  description = "AWS auto scaling max size"
  type        = number
  default     = 1
}
variable "autoscaling_min_size" {
  description = "AWS auto scaling min size"
  type        = number
  default     = 1
}


# network variables
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