terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.0"
    }
  }
  backend "s3" {
    bucket = "powerex-terraform"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    assume_role = {
      role_arn = "arn:aws:iam::795211112650:role/terraform-state"
    }
  }
}
