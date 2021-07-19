provider "aws" {
  region  = var.region
  profile = "cryptern"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }
}
