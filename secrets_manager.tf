resource "aws_secretsmanager_secret_version" "new_secret_version" {
  secret_id = aws_secretsmanager_secret.example.id
  secret_string         = jsonencode(
    {
      "host": aws_db_instance.example_rds.identifier, 
      "user": local.db_credentials.username,
      "password": local.db_credentials.password,
      "database": local.db_credentials.name
    }
  )

  depends_on = [
    data.aws_secretsmanager_secret_version.credentials
  ]
}
