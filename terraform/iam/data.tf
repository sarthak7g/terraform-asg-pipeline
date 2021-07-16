// Import existing user from aws which was not made from terraform
data "aws_iam_user" "admin" {
  user_name = "admin"
}
//Gives current aws profile
data "aws_caller_identity" "current" {}
