/*
* REPLACE <project> WITH YOUR PROJECT NAME
*/ 
output "instance-profile" {
  value = module.<project>-iam.instance-profile
}
output "codedeployrole" {
  value = module.<project>-iam.codedeployrole
}
output "codepipeline-backend-role" {
  value = module.<project>-iam.codepipeline-backend-role
}
output "codepipeline-frontend-role" {
  value = module.<project>-iam.codepipeline-frontend-role
}
output "codebuild-frontend-role" {
  value = module.<project>-iam.codebuild-frontend-role
}
