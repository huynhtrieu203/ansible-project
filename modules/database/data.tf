data "aws_subnet" "db_private_subnet" {
  count = 2
  filter {
    name   = "tag:Name"
    values = ["db_private_subnet-${count.index}"]
  }
}

data "aws_security_group" "rds_sg" {
  filter {
    name   = "tag:Name"
    values = ["rds_sg"]
  }
}
