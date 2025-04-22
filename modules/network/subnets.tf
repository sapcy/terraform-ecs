### Subnet 생성 ###
### Public Subnet 생성 ###
resource "aws_subnet" "pub_sub1" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = var.pub_sub1_cidr
  map_public_ip_on_launch = true
  availability_zone = var.zone_1
  tags = { 
    Name = "public-subnet_${var.environment}"
  }
}

### Public-Route 생성-연결 ###
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags = { 
    Name = "public-rt_${var.environment}"
  }
}

resource "aws_route" "pub_route" {
  route_table_id = aws_route_table.pub_rt.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id = aws_internet_gateway.test_igw.id
}

resource "aws_route_table_association" "pub_assoc1" {
  subnet_id = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub_rt.id
}

### Private-Route 생성 ###
### Private-Subnet 생성 ###
resource "aws_subnet" "pri_sub1" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = var.pri_sub1_cidr
  availability_zone = var.zone_1
  tags = { 
    Name = "private-subnet_${var.environment}"
  }
}

### Private-Route 생성-연결 ###
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags = { 
    Name = "private-rt_${var.environment}"
  }
}

resource "aws_route" "pri_route" {
  route_table_id = aws_route_table.pri_rt.id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id = aws_nat_gateway.test_nat.id
}

resource "aws_route_table_association" "private_assoc1" {
  subnet_id = aws_subnet.pri_sub1.id
  route_table_id = aws_route_table.pri_rt.id
}