/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <region> WITH YOUR PROJECT DEFAULT REGION, <region> like 'ap-south-1', etc..
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
*/ 

terraform {
  required_version = "~>1.0.2"
  backend "s3" {
    bucket         = "tf-remote-state.<project>.<env>"
    key            = "deployment-<project>-backend.<env>.tfstate"
    dynamodb_table = "tf-remote-state-lock.<project>.<env>"
    region         = "<region>"
    profile        = "<project>"
  }
}
