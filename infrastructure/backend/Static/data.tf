data "aws_iam_user" "backend-api-user" {
  user_name = "backend-api-user.${var.env}"
}
data "aws_caller_identity" "current" {}
