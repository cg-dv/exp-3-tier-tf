resource "aws_db_instance" "example_rds" {
  allocated_storage     = 20
  max_allocated_storage = 30
  instance_class        = "db.t3.micro"
  engine                = "mysql"
  engine_version        = "8.0"
  name                  = "example_db"
  username              = local.db_credentials.username
  password              = local.db_credentials.password
  parameter_group_name  = "default.mysql8.0"
  skip_final_snapshot   = true
  publicly_accessible   = true
  multi_az              = true
  s3_import {
    source_engine         = "mysql"
    source_engine_version = "8.0"
    bucket_name           = "snapshot-bucket-123"
    ingestion_role        = "arn:aws:iam::414402433373:role/s3-rds-access"
  }
}

output "rds_id_info" {
  value       = aws_db_instance.example_rds.identifier
  description = "Identifier of RDS instance."

  depends_on = [
    example-rds
  ]
}

output "rds_id" {
  value       = aws_db_instance.example_rds.id
  description = "Id of RDS instance."

  depends_on = [
    example-rds
  ]
}

output "rds_resource_id" {
  value       = aws_db_instance.example_rds.resource_id
  description = "Resource id of RDS instance."

  depends_on = [
    example-rds
  ]
}
