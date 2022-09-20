/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
*/ 

module "<project>-iam" {
  project   = "<project>"
  source    = "../"
  env       = "<env>"
  region    = "us-east-1"
}
