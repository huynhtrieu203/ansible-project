output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "subnets" {
  value = aws_subnet.public_subnet
}
