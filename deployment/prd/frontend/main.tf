/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <region> WITH YOUR PROJECT DEFAULT REGION, <region> like 'ap-south-1', etc..
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "<env>" in this case
*/ 

module "<project>-deployment-frontend" {
  source                = "../../frontend/"
  env                   = "<env>"
  region                = "<region>"
  part                  = "frontend"
  codeDeployRoleArn     = data.terraform_remote_state.<project>-iam-data.outputs.codedeployrole.arn
  deploymentConfigName  = "CodeDeployDefault.OneAtATime"
  asg                   = data.terraform_remote_state.<project>-infra-frontend-autoscaling.outputs.asg.name
  targetGroup           = data.terraform_remote_state.<project>-infra-frontend-autoscaling.outputs.targetGroup[0].name
  codepipelineRoleArn   = data.terraform_remote_state.<project>-iam-data.outputs.codepipeline-frontend-role.arn
  codeBuildRoleArn      = data.terraform_remote_state.<project>-iam-data.outputs.codebuild-frontend-role.arn
  appZip                = "<project>-frontend.zip"
  envVariables          = ["NEXT_PUBLIC_API_BASE_URL", "NEXT_PUBLIC_CHAT_BASE_URL", "NEXT_PUBLIC_LOCATION_API_KEY"]
  vpc                   = data.terraform_remote_state.<project>-infra-data.outputs.vpc
  privateSubnet         = [for subnet in data.terraform_remote_state.<project>-infra-data.outputs.private-subnet : subnet.id]
  publicSecurityGroupId = [data.terraform_remote_state.<project>-infra-data.outputs.public-sg.id]
}
