output "instance-profile" {
  value = aws_iam_instance_profile.instance-profile
}
output "codedeployrole" {
  value = aws_iam_role.codedeploy
}
output "codepipeline-backend-role" {
  value = aws_iam_role.codepipeline-backend-role
}
output "codepipeline-frontend-role" {
  value = aws_iam_role.codepipeline-frontend-role
}
output "codebuild-frontend-role" {
  value = aws_iam_role.codebuild-frontend-role
}
