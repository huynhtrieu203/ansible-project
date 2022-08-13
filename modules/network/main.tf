// Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "vpc"
  }
}

// Create 2 public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cird[count.index]
  map_public_ip_on_launch = "true" //Makes subnet public
  availability_zone       = var.availability_zone[count.index]
  count                   = length(var.public_cird)
  tags = {
    Name = "public_subnet-${count.index}"
  }
}

// Create internet gateway to access to internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

// Configure route table
resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_route
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-crt"
  }
}

// Attach to subnet
resource "aws_route_table_association" "crta-public" {
  subnet_id      = aws_subnet.public_subnet[count.index].id
  count          = length(var.public_cird)
  route_table_id = aws_route_table.public-crt.id
}

// Create private subnet
resource "aws_subnet" "db_private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cird[count.index]
  availability_zone = var.availability_zone[count.index]
  count             = length(var.private_cird)

  tags = {
    Name = "db_private_subnet-${count.index}"
  }
}

// Create ALB security group
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "alb_sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.cidr_route}"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_route}"]
  }

  tags = {
    Name = "alb_sg"
  }
}

// Create instances security group
resource "aws_security_group" "instances_sg" {
  description = "Allows ALB to access the EC2 instances"
  name        = "instances_sg"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.cidr_route}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_route}"]
  }

  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  # ingress {
  #   from_port   = 8443
  #   to_port     = 8443
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  tags = {
    Name = "instances_sg"
  }
}

// Create Database Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allows application to access the RDS instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.instances_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_route}"]
  }
  tags = {
    Name = "rds_sg"
  }
}
