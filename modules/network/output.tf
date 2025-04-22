output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.test_vpc.id
}
output "pri_sub1_id" {
  description = "PRIVATE SUBNET1"
  value = aws_subnet.pri_sub1.id
}
output "pri_rt_id" {
 description = "ROUTING TABLE ID"
 value = aws_route_table.pri_rt.id
}
output "ecs_sg_id" {
  description = "ECS Security Group ID"
  value = aws_security_group.ecs_sg.id
}