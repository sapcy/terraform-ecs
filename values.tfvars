# common variables
# AWS credentials
access_key = ""
secret_key = ""
region = "us-east-1"

### zone ### 
zone_1 = "us-east-1a"

# cluster variables
ecr_arn = "arn:aws:ecr:us-east-1:442426881206:repository/{repo_name}"
ecr_url = "{user}.dkr.ecr.us-east-1.amazonaws.com/test-ns/test-repo:latest"
log_group = "/ecs/"
log_stream = "ecs"
namespace = "test-ns"
environment = "test"
instance_type = "t2.micro"
maximum_scaling_step_size = 1
minimum_scaling_step_size = 1
target_capacity = 1
ecs_task_max_count = 1
ecs_task_min_count = 1
ecs_task_desired_count = 1
cpu_target_tracking_desired_value = 256
memory_target_tracking_desired_value = 512
autoscaling_max_size = 1
autoscaling_min_size = 1

# network variables
# vpc
vpc_cidr = "192.168.0.0/16"
instance_tenancy = "default"

### Subnet ###
### public subnet ###
pub_sub1_cidr = "192.168.20.0/28"


### private-subnet ###
pri_sub1_cidr = "192.168.10.0/28"

# igw_id = ""
destination_cidr_block = "0.0.0.0/0"