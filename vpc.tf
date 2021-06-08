data "aws_availability_zones" "available_azs" {
  state = "available"
}

######## VPC 0 ########
resource "aws_vpc" "vpc_0" {
  cidr_block           = "172.100.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "vpc_0"
  }
}

######## Internet GW 0 ########
resource "aws_internet_gateway" "internet_gw_0" {
  vpc_id = aws_vpc.vpc_0.id
  tags = {
    Name = "internet_gw_0"
  }
  depends_on = [aws_vpc.vpc_0]
}

######## Public Subnet 0 ########
resource "aws_subnet" "public_subnet_0" {
  cidr_block              = "172.100.0.0/24"
  availability_zone       = data.aws_availability_zones.available_azs.names[0]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc_0.id
  tags = {
    Name = "public_subnet_0"
  }
  depends_on = [aws_vpc.vpc_0]
}

resource "aws_route_table" "public_route_0" {
  vpc_id = aws_vpc.vpc_0.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw_0.id
  }
  route {
    cidr_block         = "172.200.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.transit_gateway_main.id
  }
  tags = {
    Name = "public_route_0"
  }
  depends_on = [
    aws_internet_gateway.internet_gw_0,
    aws_ec2_transit_gateway.transit_gateway_main,
    aws_ec2_transit_gateway_vpc_attachment.transit_gateway_vpc_attachment_0
  ]
}

resource "aws_main_route_table_association" "main_route_table_association_vpc_0_public_route_0" {
  vpc_id         = aws_vpc.vpc_0.id
  route_table_id = aws_route_table.public_route_0.id
  depends_on = [
    aws_vpc.vpc_0,
    aws_route_table.public_route_0
  ]
}

resource "aws_route_table_association" "assoc_table_public_subnet_0_public_route_0" {
  subnet_id      = aws_subnet.public_subnet_0.id
  route_table_id = aws_route_table.public_route_0.id
  depends_on     = [aws_subnet.public_subnet_0, aws_route_table.public_route_0]
}

######## VPC 1 ########
resource "aws_vpc" "vpc_1" {
  cidr_block           = "172.200.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "vpc_1"
  }
}

######## Internet GW 1 ########
resource "aws_internet_gateway" "internet_gw_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = {
    Name = "internet_gw_1"
  }
  depends_on = [aws_vpc.vpc_1]
}

######## Public Subnet 1 ########
resource "aws_subnet" "public_subnet_1" {
  cidr_block              = "172.200.1.0/24"
  availability_zone       = data.aws_availability_zones.available_azs.names[0]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc_1.id
  tags = {
    Name = "public_subnet_1"
  }
  depends_on = [aws_vpc.vpc_1]
}

resource "aws_route_table" "public_route_1" {
  vpc_id = aws_vpc.vpc_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw_1.id
  }
  route {
    cidr_block         = "172.100.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.transit_gateway_main.id
  }
  tags = {
    Name = "public_route_1"
  }
  depends_on = [
    aws_internet_gateway.internet_gw_1,
    aws_ec2_transit_gateway.transit_gateway_main,
    aws_ec2_transit_gateway_vpc_attachment.transit_gateway_vpc_attachment_1
  ]
}

resource "aws_main_route_table_association" "main_route_table_association_vpc_1_public_route_1" {
  vpc_id         = aws_vpc.vpc_1.id
  route_table_id = aws_route_table.public_route_1.id
  depends_on = [
    aws_vpc.vpc_1,
    aws_route_table.public_route_1
  ]
}

resource "aws_route_table_association" "assoc_table_public_subnet_1_public_route_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_1.id
  depends_on     = [aws_subnet.public_subnet_1, aws_route_table.public_route_1]
}

######## Nat GW 1 ########
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.eip_nat_gw.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "nat_gw_1"
  }
  depends_on = [
    aws_eip.eip_nat_gw,
    aws_subnet.public_subnet_1
  ]
}

######## Private Subnet 1 ########
resource "aws_subnet" "private_subnet_1" {
  cidr_block              = "172.200.0.0/24"
  availability_zone       = data.aws_availability_zones.available_azs.names[0]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc_1.id
  tags = {
    Name = "private_subnet_1"
  }
  depends_on = [aws_vpc.vpc_1]
}

resource "aws_route_table" "private_route_1" {
  vpc_id = aws_vpc.vpc_1.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }
  route {
    cidr_block         = "172.100.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.transit_gateway_main.id
  }
  tags = {
    Name = "private_route_1"
  }
  depends_on = [
    aws_nat_gateway.nat_gw_1,
    aws_ec2_transit_gateway.transit_gateway_main,
    aws_ec2_transit_gateway_vpc_attachment.transit_gateway_vpc_attachment_1
  ]
}

resource "aws_route_table_association" "assoc_table_private_subnet_1_private_route_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_1.id
  depends_on     = [aws_subnet.private_subnet_1, aws_route_table.private_route_1]
}
