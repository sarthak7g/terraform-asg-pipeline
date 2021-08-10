data "terraform_remote_state" "cryptern-iam-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.dev"
    key            = "iam-cryptern.dev.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.dev"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
data "terraform_remote_state" "cryptern-infra-backend-autoscaling" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.dev"
    key            = "infrastructure-cryptern-autoscaling-backend.dev.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.dev"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
