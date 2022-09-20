/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
*/ 

data "terraform_remote_state" "<project>-infra-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.<project>.<env>"
    key            = "infrastructure-<project>.<env>.tfstate"
    dynamodb_table = "tf-remote-state-lock.<project>.<env>"
    region         = "us-east-1"
    profile        = "<project>"
  }
}
data "terraform_remote_state" "<project>-iam-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.<project>.<env>"
    key            = "iam-<project>.<env>.tfstate"
    dynamodb_table = "tf-remote-state-lock.<project>.<env>"
    region         = "us-east-1"
    profile        = "<project>"
  }
}
