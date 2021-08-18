output "instance-profile" {
  value = module.cryptern-iam.instance-profile
}
output "codedeployrole" {
  value = module.cryptern-iam.codedeployrole
}
output "codepipeline-backend-role" {
  value = module.cryptern-iam.codepipeline-backend-role
}
output "codepipeline-frontend-role" {
  value = module.cryptern-iam.codepipeline-frontend-role
}
output "codebuild-frontend-role" {
  value = module.cryptern-iam.codebuild-frontend-role
}
