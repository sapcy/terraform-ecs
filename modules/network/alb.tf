
# ### LB 구성 ####
# ### 보안그룹 - ALB ###
# resource "aws_security_group" "SG_alb" {
#   name = "WEBSG"
#   description = "Allow HTTP(80/tcp, 8080/tcp)"
#   vpc_id = var.vpc_id
#   ingress {
#     description = "Allow HTTP(80)"
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
 
#   ingress {
#     description = "Allow HTTPs(8080)"
#     from_port = 8080
#     to_port = 8080
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "SG_alb"
#   }
# }
# ### ALB 생성 ###
# resource "aws_lb" "ALB" {
#   name = "myALB"
#   load_balancer_type = "application"
#   subnets = [
#     var.pub_sub1_id,
#     var.pub-sub2-id
#   ]
#   security_groups = [aws_security_group.SG_alb.id]
# }
# ### ALB Listner 생성 ###
# resource "aws_lb_listener" "ALB-Listener" {
#   load_balancer_arn = aws_lb.ALB.arn
#   port = 80
#   protocol = "HTTP"
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.ALB-TG.arn
#   }
# }
# ### Tagret Group 생성 ###
# resource "aws_lb_target_group" "ALB-TG" {
#   name = "myALB-TG"
#   port = 80
#   protocol = "HTTP"
#   target_type = "ip"
#   vpc_id = var.vpc_id
# }