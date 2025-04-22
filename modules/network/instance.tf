### keypair ###
# resource "aws_key_pair" "ssh_key" {
#   key_name   = "ssh_key"
#   public_key = file("~/.ssh/ssh_key.pub")
# }

### 보안그룹 - instance ###
resource "aws_security_group" "ecs_sg" {
  name = "ecs_sg"
  description = "Allow HTTP(80/tcp, 8080/tcp), ssh(22/tcp)"
  vpc_id = aws_vpc.test_vpc.id

  ingress {
    description = "Allow HTTP(80)"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ssh(22)"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg_${var.environment}"
  }
}