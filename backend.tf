terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/key"
    region         = "us-west-2"
    dynamodb_table = "my-lock-table"
  }
}
