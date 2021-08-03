data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = "db_credentials"
}

locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.credentials.secret_string
  )
}
