
terraform {
  backend "s3" {
    bucket = "terraform-task-bucket"
    key    = "task/terraform.tfstate"
    region = "eu-central-1"
  }
}