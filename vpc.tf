resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id
}

resource "aws_default_route_table" "route_to_internet" {
  default_route_table_id = aws_vpc.example.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "example_subnet_1" {
  vpc_id               = aws_vpc.example.id
  cidr_block           = "10.0.1.0/24"
  availability_zone_id = "usw1-az1"
}

resource "aws_subnet" "example_subnet_2" {
  vpc_id               = aws_vpc.example.id
  cidr_block           = "10.0.2.0/24"
  availability_zone_id = "usw1-az3"
}

resource "aws_vpc_endpoint" "secrets-manager-endpoint" {
  vpc_id       = aws_vpc.example.id
  service_name = "com.amazonaws.us-west-1.secretsmanager"

  security_group_ids = [aws_security_group.vpc-endpoint-secrets-manager.id]
}
