terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "common" {
  source = "./common"

  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

module "cluster" {
  source = "./modules/cluster"

  ecr_arn    = var.ecr_arn
  ecr_url     = var.ecr_url
  log_group   = var.log_group
  log_stream  = var.log_stream
  environment  = var.environment
  instance_type = var.instance_type
  namespace  = var.namespace
  maximum_scaling_step_size = var.maximum_scaling_step_size
  minimum_scaling_step_size = var.minimum_scaling_step_size
  target_capacity = var.target_capacity
  ecs_task_max_count = var.ecs_task_max_count
  ecs_task_min_count = var.ecs_task_min_count
  ecs_task_desired_count = var.ecs_task_desired_count
  cpu_target_tracking_desired_value = var.cpu_target_tracking_desired_value
  memory_target_tracking_desired_value = var.memory_target_tracking_desired_value
  autoscaling_max_size = var.autoscaling_max_size
  autoscaling_min_size = var.autoscaling_min_size
  
  pri_sub1_id = module.network.pri_sub1_id
  vpc_id      = module.network.vpc_id
  ecs_sg_id   = module.network.ecs_sg_id
}

module "network" {
  source = "./modules/network"

  vpc_cidr              = var.vpc_cidr
  pri_sub1_cidr         = var.pri_sub1_cidr
  pub_sub1_cidr         = var.pub_sub1_cidr
  instance_tenancy      = var.instance_tenancy
  zone_1                = var.zone_1
  destination_cidr_block= var.destination_cidr_block
  environment          = var.environment
}