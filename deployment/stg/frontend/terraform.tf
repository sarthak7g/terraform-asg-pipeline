terraform {
  required_version = "~>1.0.2"
  backend "s3" {
    bucket         = "tf-remote-state.cryptern.stg"
    key            = "deployment-cryptern-frontend.stg.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.stg"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
