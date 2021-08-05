resource "aws_db_instance" "example_rds" {
  allocated_storage     = 20
  max_allocated_storage = 30
  instance_class        = "db.t3.micro"
  engine                = "mysql"
  engine_version        = "8.0.23"
  name                  = "example_db"
  username              = local.db_credentials.user
  password              = local.db_credentials.password
  parameter_group_name  = "default.mysql8.0"
  skip_final_snapshot   = true
  publicly_accessible   = true
  multi_az              = false
  snapshot_identifier   = "arn:aws:rds:us-west-1:414402433373:snapshot:snapshot-07-13-2021"
}

output "rds_id_endpoint" {
  value       = aws_db_instance.example_rds.endpoint
  description = "Endpoint of RDS instance."

  depends_on = [
    aws_db_instance.example_rds
  ]
}

output "rds_id" {
  value       = aws_db_instance.example_rds.id
  description = "Id of RDS instance."

  depends_on = [
    aws_db_instance.example_rds
  ]
}
