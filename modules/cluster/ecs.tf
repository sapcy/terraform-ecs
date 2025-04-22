### ECS 역할 정책 ###
### 정책-task ###
data "aws_iam_policy_document" "ecs_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ecr_policy_doc" {
  statement {
    sid    = "s1"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      var.ecr_arn
    ]
  }
}
data "aws_iam_policy_document" "get_authentication" {
  statement {
    sid    = "s1"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name   = "ecr_repo_policy"
  policy = data.aws_iam_policy_document.ecr_policy_doc.json
}
resource "aws_iam_policy" "getAuth_policy" {
  name   = "get_auth_policy"
  policy = data.aws_iam_policy_document.get_authentication.json
}

### 역할-task ###
resource "aws_iam_role" "ecs_role" {
  name = "test-ecs-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role.json
}
### Policy-ECS ###
resource "aws_iam_role_policy_attachment" "ecs_fullAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
### Policy-ECS-Task ###
resource "aws_iam_role_policy_attachment" "ecs-taskExecutionRolePolicy" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# ### Policy-S3 ###
# resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
#   role = aws_iam_role.ecs_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }
### Policy - cloudwatch_logs ###
resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
resource "aws_iam_role_policy_attachment" "CloudWatchReadOnlyAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonAPIGatewayPushToCloudWatchLogs" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::442426881206:policy/ecr_repo_policy"
  
  depends_on = [
    aws_iam_policy.ecr_policy
  ]
}
resource "aws_iam_role_policy_attachment" "getAuth_policy" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::442426881206:policy/get_auth_policy"

  depends_on = [
    aws_iam_policy.getAuth_policy
  ]
}


### ECS 생성 ###
### ECS_Task_Definition ###
resource "aws_ecs_task_definition" "ecs_task_def" {
  family = "ecs_task_def"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_role.arn
  cpu = 256
  memory = 512
  requires_compatibilities = ["EC2"] 
  task_role_arn = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode([
    {
      "name": "nginx",
      "image": "${var.ecr_url}",  

      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "name": "http",
          "containerPort": 80,
          "hostPort": 80,
          "appProtocol": "http"
        }
      ],
      "logconfiguration" : {
        "logdriver" : "awslogs",
        "options"    : {
          "awslogs-group"         : "${var.log_group}",
          "awslogs-region"        : "${var.region}",
          "awslogs-stream-prefix" : "${var.log_stream}",
        }
      } 
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }
}

### ECS Cluster ###
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "test-ecs-cluster-1" 
    setting {
    name  = "containerInsights"
   
    value = "enabled"
  }
}

### ECS service ###
resource "aws_ecs_service" "ecs_service" {
  name = "test-ecs-service-1" 
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  launch_type = "EC2"
  desired_count = 1

  

  # launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]  
    subnets = [
      var.pri_sub1_id
    ]
    #assign_public_ip = true
  }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.ALB-TG.arn
  #   container_name = aws_ecs_task_definition.ecs_task_def.family
  #   container_port = 80
  # }
}

resource "aws_security_group" "ecs_sg" {
  name = "test-ecs-sg-1"
  description = "Allow HTTP(80)"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow HTTP(80)"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH(22)"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_${var.environment}"
  }
}

## Instance
### IAM
resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.namespace}_EC2_InstanceRole_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role_profile" {
  name  = "${var.namespace}_EC2_InstanceRoleProfile_${var.environment}"
  role  = aws_iam_role.ec2_instance_role.id
}

data "aws_iam_policy_document" "ec2_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}


### 이미지(AMI)
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

data "aws_ami" "amazon_linux_3" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-x86_64"]
  }

  owners = ["amazon"]
}

### Launch template
resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${var.namespace}_EC2_LaunchTemplate_${var.environment}"
  image_id               = data.aws_ami.amazon_linux_3.id
  instance_type          = var.instance_type
  # key_name               = aws_key_pair.default.key_name
  user_data              = base64encode(local.user_data) #base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [var.ecs_sg_id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_role_profile.arn
  }

  monitoring {
    enabled = true
  }
}

locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    ecs_cluster_name = aws_ecs_cluster.ecs_cluster.name
  })
}

### Capacity provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name  = "${var.namespace}_ECS_CapacityProvider_${var.environment}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_autoscaling_group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = var.maximum_scaling_step_size
      minimum_scaling_step_size = var.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cas" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]
}

### Define Target Tracking on ECS Cluster Task level
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.ecs_task_max_count
  min_capacity       = var.ecs_task_min_count
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

### Policy for CPU tracking
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "${var.namespace}_CPUTargetTrackingScaling_${var.environment}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_target_tracking_desired_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

### Policy for memory tracking
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "${var.namespace}_MemoryTargetTrackingScaling_${var.environment}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_target_tracking_desired_value

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

## Creates an ASG linked with our main VPC

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                  = "${var.namespace}_ASG_${var.environment}"
  max_size              = var.autoscaling_max_size
  min_size              = var.autoscaling_min_size
  vpc_zone_identifier   = [var.pri_sub1_id]
  health_check_type     = "EC2"
  protect_from_scale_in = true

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest" # 예약어 - Launch Template의 가장 최근 버전 번호
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.namespace}_ASG_${var.environment}"
    propagate_at_launch = true
  }
}


