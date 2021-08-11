terraform {
  required_version = ">= 0.13.0"
}

resource "random_id" "id" {
  byte_length = 8
}

# Create a name with a randomized value
locals {
    name =  "{$var.name}-${random_id.id.hex}"
    tags = {
        Name = local.name
    }
}

provider "aws" {
  region = var.aws_region
}

# Search for an AMI for the instances
data "aws_ami" "bitnami_nginx" {
  most_recent = true
  filter {
    name   = "name"
    values = ["bitnami-nginx-1.16*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["979382823631"] 
}

# Create the VPC "myvpc"
resource "aws_vpc" "myvpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = local.tags
}

# Create the default security group allowing ingress/egress internet access
resource "aws_security_group" "default" {
  name        = "${local.name}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.myvpc.id
  depends_on  = [aws_vpc.myvpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [aws_vpc.myvpc.cidr_block, "0.0.0.0/0"]
    self      = true
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
  }
  tags = local.tags
}

# Create the internet gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = local.tags
}

# Create the subnet #1 in AZ #1
resource "aws_subnet" "subnet_public_1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.cidr_subnet_1
  tags = local.tags
  availability_zone = var.aws_region_az_1
}

# Create the subnet #1 in AZ #2
resource "aws_subnet" "subnet_public_2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.cidr_subnet_2
  tags = local.tags
  availability_zone = var.aws_region_az_2
}

# Route table allowing egress to the IGW. A local (vpc CIDR) route is created automatically.
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.tags
}

# Make the route the main route of the VPC
resource "aws_main_route_table_association" "rta_vpc" {
  vpc_id         = aws_vpc.myvpc.id
  route_table_id = aws_route_table.rtb_public.id
}

# In case you want to explicitly assign the route to the subnet without using the main VPC route table
#resource "aws_route_table_association" "rta_subnet_public_1" {
#  subnet_id      = aws_subnet.subnet_public_1.id
#  route_table_id = aws_route_table.rtb_public.id
#}

# In case you want to explicitly assign the route to the subnet without using the main VPC route table
#resource "aws_route_table_association" "rta_subnet_public_2" {
#  subnet_id      = aws_subnet.subnet_public_2.id
#  route_table_id = aws_route_table.rtb_public.id
#}

# Create 2 demo nginx instances
resource "aws_instance" "nginx_1" {
  ami                         = data.aws_ami.bitnami_nginx.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_public_1.id
  tags                        = local.tags
  vpc_security_group_ids = [aws_security_group.default.id]
}
resource "aws_instance" "nginx_2" {
  ami                         = data.aws_ami.bitnami_nginx.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_public_2.id
  tags                        = local.tags
  vpc_security_group_ids = [aws_security_group.default.id]
}
