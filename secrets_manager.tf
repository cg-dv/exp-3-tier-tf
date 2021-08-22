resource "aws_secretsmanager_secret_version" "new_secret_version" {
  secret_id = "arn:aws:secretsmanager:us-west-1:414402433373:secret:db_credentials-YsLYyk"
  secret_string = jsonencode(
    {
      "host" : aws_db_instance.example_rds.endpoint,
      "username" : local.db_credentials.username,
      "password" : local.db_credentials.password,
      "database" : local.db_credentials.database
    }
  )

  depends_on = [
    data.aws_secretsmanager_secret_version.credentials
  ]
}
