provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
      bucket = "terraform-state-store-online"
      key = "terraform.tfstate"
      region = "ap-southeast-1"
      dynamodb_table = "terraform_locks"
  }
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

provider "http" {
}
