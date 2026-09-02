terraform {
  backend "s3" {
    bucket         = "terraform-state-650468121449"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
