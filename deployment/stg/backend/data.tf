data "terraform_remote_state" "cryptern-iam-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.stg"
    key            = "iam-cryptern.stg.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.stg"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
data "terraform_remote_state" "cryptern-infra-backend-autoscaling" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.stg"
    key            = "infrastructure-cryptern-autoscaling-backend.stg.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.stg"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
