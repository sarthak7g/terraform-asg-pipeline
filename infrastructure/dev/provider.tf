provider "aws" {
  region  = "us-east-1"
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
