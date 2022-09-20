/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
*/ 
terraform {
  required_version = "~>1.0.2"
  backend "s3" {
    bucket         = "tf-remote-state.<project>.<env>"
    key            = "infrastructure-<project>.<env>.tfstate"
    dynamodb_table = "tf-remote-state-lock.<project>.<env>"
    region         = "us-east-1"
    profile        = "<project>"
  }
}
