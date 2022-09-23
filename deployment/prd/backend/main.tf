/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <region> WITH YOUR PROJECT DEFAULT REGION, <region> like 'ap-south-1', etc..
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "<env>" in this case
*/ 

module "<project>-deployment-backend" {
  source               = "../../backend/"
  env                  = "<env>"
  region               = "<region>"
  part                 = "backend"
  codeDeployRoleArn    = data.terraform_remote_state.<project>-iam-data.outputs.codedeployrole.arn
  deploymentConfigName = "CodeDeployDefault.OneAtATime"
  asg                  = data.terraform_remote_state.<project>-infra-backend-autoscaling.outputs.asg.name
  targetGroup          = data.terraform_remote_state.<project>-infra-backend-autoscaling.outputs.targetGroup[0].name
  codepipelineRoleArn  = data.terraform_remote_state.<project>-iam-data.outputs.codepipeline-backend-role.arn
  appZip               = "<project>-api.zip"
}
