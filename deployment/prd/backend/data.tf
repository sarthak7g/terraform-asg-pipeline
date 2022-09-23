/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <region> WITH YOUR PROJECT DEFAULT REGION, <region> like 'ap-south-1', etc..
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "<env>" in this case
*/ 

data "terraform_remote_state" "<project>-iam-data" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.<project>.<env>"
    key            = "iam-<project>.<env>.tfstate"
    dynamodb_table = "tf-remote-state-lock.<project>.<env>"
    region         = "<region>"
    profile        = "<project>"
  }
}
data "terraform_remote_state" "<project>-infra-backend-autoscaling" {
  backend = "s3"
  config = {
    bucket         = "tf-remote-state.<project>.<env>"
    key            = "infrastructure-<project>-autoscaling-backend.<env>.tfstate"
    dynamodb_table = "tf-remote-state-lock.<project>.<env>"
    region         = "<region>"
    profile        = "<project>"
  }
}
