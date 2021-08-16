module "cryptern-deployment-frontend" {
  source               = "../../"
  env                  = "dev"
  region               = "us-east-1"
  part                 = "frontend"
  codeDeployRoleArn    = data.terraform_remote_state.cryptern-iam-data.outputs.codedeployrole.arn
  deploymentConfigName = "CodeDeployDefault.OneAtATime"
  asg                  = data.terraform_remote_state.cryptern-infra-frontend-autoscaling.outputs.asg.name
  targetGroup          = data.terraform_remote_state.cryptern-infra-frontend-autoscaling.outputs.targetGroup[0].name
  codepipelineRoleArn  = data.terraform_remote_state.cryptern-iam-data.outputs.codepipeline-frontend-role.arn
  appZip               = "crypterns-frontend.zip"
}
