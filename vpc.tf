resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_nat_gateway" "public-NAT-gw" {
  allocation_id = aws_eip.NAT-eip.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [aws_eip.NAT-eip]
}

resource "aws_eip" "NAT-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_default_route_table" "default-private-route-table" {
  default_route_table_id = aws_vpc.example.default_route_table_id

  route = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.public-NAT-gw.id
    }
  ]
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.example.id

  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  ]
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id               = aws_vpc.example.id
  cidr_block           = "10.0.1.0/24"
  availability_zone_id = "usw1-az1"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id               = aws_vpc.example.id
  cidr_block           = "10.0.2.0/24"
  availability_zone_id = "usw1-az3"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id               = aws_vpc.example.id
  cidr_block           = "10.0.3.0/24"
  availability_zone_id = "usw1-az1"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id               = aws_vpc.example.id
  cidr_block           = "10.0.4.0/24"
  availability_zone_id = "usw1-az3"
}

resource "aws_vpc_endpoint" "secrets-manager-endpoint" {
  vpc_id              = aws_vpc.example.id
  service_name        = "com.amazonaws.us-west-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc-endpoint-secrets-manager.id]
}
