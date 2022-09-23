provider "aws" {
  region  = var.region
  profile = "${var.project}"
}