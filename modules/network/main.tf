resource "aws_vpc" "my-vpc" {
  cidr_block           = var.cidr_block
  tags = {
    Name = "DemoVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.public_subnet[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = var.azs[count.index]
  count                   = length(var.public_subnet)
  tags = {
    Name = "public_subnet-${count.index}"
  }
}

resource "aws_subnet" "db_private_subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.azs[count.index]
  count             = length(var.private_subnet)

  tags = {
    Name = "db_private_subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = var.cidr_block_any
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-crt"
  }
}

resource "aws_route_table_association" "crta-public" {
  subnet_id      = aws_subnet.public_subnet[count.index].id
  count          = length(var.public_subnet)
  route_table_id = aws_route_table.public-crt.id
}

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.my-vpc.id
  name   = "alb_sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.cidr_block_any}"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_any}"]
  }

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group" "instances_sg" {
  description = "Allows ALB to access the EC2 instances"
  name        = "instances_sg"
  vpc_id      = aws_vpc.my-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.cidr_block_any}"]
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
    cidr_blocks = ["${var.cidr_block_any}"]
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

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allows application to access the RDS instances"
  vpc_id      = aws_vpc.my-vpc.id

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
    cidr_blocks = ["${var.cidr_block_any}"]
  }
  tags = {
    Name = "rds_sg"
  }
}
