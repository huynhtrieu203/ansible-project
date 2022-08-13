data "aws_subnet" "public_subnet" {
  count = 2
  filter {
    name   = "tag:Name"
    values = ["public_subnet-${count.index}"]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc"]
  }
}

data "aws_security_group" "instances_sg" {
  filter {
    name   = "tag:Name"
    values = ["instances_sg"]
  }
}

data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["alb_sg"]
  }
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb.dns_name
}
