terraform {
  required_version = "~>1.0.2"
  backend "s3" {
    bucket         = "tf-remote-state.cryptern.dev"
    key            = "deployment-cryptern-frontend.dev.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.dev"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
