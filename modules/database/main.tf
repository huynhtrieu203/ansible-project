resource "aws_db_subnet_group" "subnetgroup" {
  name       = "miniproject-subnetgroup"
  subnet_ids = [for subnet in data.aws_subnet.db_private_subnet : subnet.id]

  tags = {
    Name = "subnetgroup"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "rds"
  instance_class          = var.instance_class
  allocated_storage       = var.storage
  apply_immediately       = true
  engine                  = var.engine
  engine_version          = var.engine_version
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.subnetgroup.name
  vpc_security_group_ids  = [data.aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  backup_retention_period = 1
}

resource "aws_db_instance" "rds_replica" {
  identifier             = "rds-replica"
  replicate_source_db    = aws_db_instance.rds.identifier
  instance_class         = var.instance_class
  apply_immediately      = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [data.aws_security_group.rds_sg.id]
}
