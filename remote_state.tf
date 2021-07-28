terraform {
  backend "s3" {
    bucket = "terraform-remote-state-bucket-123"
    key    = "express_form/dev/terraform.tfstate"
    region = "us-west-1"
  }
}
