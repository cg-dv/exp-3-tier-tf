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
  skip_final_snapshot    = true
  publicly_accessible    = true
  multi_az               = false
  snapshot_identifier    = "arn:aws:rds:us-west-1:414402433373:snapshot:snapshot-07-13-2021"
}
