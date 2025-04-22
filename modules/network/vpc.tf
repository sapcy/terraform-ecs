resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.instance_tenancy
  tags = { 
    Name = "vpc_${var.environment}"
  }
}

### Internet gateway 생성 ###
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = { 
    Name = "igw_${var.environment}"
  }
}

### Elastic Ip 생성 ###
resource "aws_eip" "test_eip" {
  # domain = "vpc"
}
### NAT gateway 생성 ###
resource "aws_nat_gateway" "test_nat" {
  allocation_id = aws_eip.test_eip.id
  subnet_id = aws_subnet.pub_sub1.id
  tags = { 
    Name = "nat_${var.environment}"
  }
}