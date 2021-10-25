data "terraform_remote_state" "cryptern-iam-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.prd"
    key            = "iam-cryptern.prd.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.prd"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
data "terraform_remote_state" "cryptern-infra-frontend-autoscaling" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.prd"
    key            = "infrastructure-cryptern-autoscaling-frontend.prd.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.prd"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
data "terraform_remote_state" "cryptern-infra-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.cryptern.prd"
    key            = "infrastructure-cryptern.prd.tfstate"
    dynamodb_table = "tf-remote-state-lock.cryptern.prd"
    region         = "us-east-1"
    profile        = "cryptern"
  }
}
