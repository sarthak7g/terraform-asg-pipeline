module "cryptern-deployment-frontend" {
  source                = "../../frontend/"
  env                   = "prd"
  region                = "us-east-1"
  part                  = "frontend"
  codeDeployRoleArn     = data.terraform_remote_state.cryptern-iam-data.outputs.codedeployrole.arn
  deploymentConfigName  = "CodeDeployDefault.OneAtATime"
  asg                   = data.terraform_remote_state.cryptern-infra-frontend-autoscaling.outputs.asg.name
  targetGroup           = data.terraform_remote_state.cryptern-infra-frontend-autoscaling.outputs.targetGroup[0].name
  codepipelineRoleArn   = data.terraform_remote_state.cryptern-iam-data.outputs.codepipeline-frontend-role.arn
  codeBuildRoleArn      = data.terraform_remote_state.cryptern-iam-data.outputs.codebuild-frontend-role.arn
  appZip                = "crypterns-frontend.zip"
  envVariables          = ["NEXT_PUBLIC_API_BASE_URL", "NEXT_PUBLIC_CHAT_BASE_URL", "NEXT_PUBLIC_LOCATION_API_KEY"]
  vpc                   = data.terraform_remote_state.cryptern-infra-data.outputs.vpc
  privateSubnet         = [for subnet in data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet : subnet.id]
  publicSecurityGroupId = [data.terraform_remote_state.cryptern-infra-data.outputs.public-sg.id]
}
