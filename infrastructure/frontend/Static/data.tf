data "aws_caller_identity" "current" {}
data "aws_iam_user" "gitlab" {
  user_name = "gitlab-${var.env}"
}