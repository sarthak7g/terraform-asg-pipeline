terraform {
  required_version = "~>1.0.2"
  backend "s3" {
    bucket         = "tf-remote-state.cryptern.prd"
    key            = "iam-cryptern.prd.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.prd"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
