module "cryptern-deployment-backend" {
  source               = "../../"
  env                  = "dev"
  region               = "us-east-1"
  part                 = "backend"
  codeDeployRoleArn    = data.terraform_remote_state.cryptern-iam-data.outputs.codedeployrole.arn
  deploymentConfigName = "CodeDeployDefault.OneAtATime"
  asg                  = data.terraform_remote_state.cryptern-infra-backend-autoscaling.outputs.asg.name
  targetGroup          = data.terraform_remote_state.cryptern-infra-backend-autoscaling.outputs.targetGroup[0].name
  codepipelineRoleArn  = data.terraform_remote_state.cryptern-iam-data.outputs.codepipeline-backend-role.arn
  appZip               = "cryptern-api.zip"
}
