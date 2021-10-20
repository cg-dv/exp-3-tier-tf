resource "aws_db_subnet_group" "mysql-db-subnets" {

  name       = "mysql-rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "RDS"
  }
}

resource "aws_db_instance" "example_rds" {
  allocated_storage      = 20
  max_allocated_storage  = 30
  instance_class         = "db.t3.micro"
  engine                 = "mysql"
  engine_version         = "8.0.23"
  name                   = "example_db"
  username               = local.db_credentials.username
  password               = local.db_credentials.password
  db_subnet_group_name   = aws_db_subnet_group.mysql-db-subnets.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = false
  multi_az               = true
  snapshot_identifier    = "arn:aws:rds:us-west-1:414402433373:snapshot:snapshot-07-13-2021"
  backup_retention_period = 1
  final_snapshot_identifier = "mysql-final-snapshot-id"
}

resource "aws_db_instance" "example_rds-replica" {
  allocated_storage      = 20
  max_allocated_storage  = 30
  instance_class         = "db.t3.micro"
  engine                 = "mysql"
  engine_version         = "8.0.23"
  name                   = "example_db-replica"
  username               = local.db_credentials.username
  password               = local.db_credentials.password
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = true
  snapshot_identifier    = "arn:aws:rds:us-west-1:414402433373:snapshot:snapshot-07-13-2021"
  replicate_source_db    = aws_db_instance.example_rds.id
}
