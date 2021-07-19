/*
 Admin role on account level
*/
resource "aws_iam_role" "admin-role" {
  name = "admin-role-${var.env}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {}
      }
    ]
  })
}
/*
 Policy to read and write terraform state 
*/
resource "aws_iam_policy" "terraform-state-rw" {
  name        = "iam-state-rw.cryptern.${var.env}"
  description = "Read/Write access to terraform state"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::tf-remote-state.cryptern.${var.env}"
      },
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        "Resource" : "arn:aws:s3:::tf-remote-state.cryptern.${var.env}/iam-cryptern.${var.env}.tfstate"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : "arn:aws:dynamodb:::table/tf-remote-state-lock.cryptern.${var.env}"
      }
    ]
  })

}
/*
 Policy attached to admin role which gives account to access terraform state with read and write permission
*/
resource "aws_iam_role_policy_attachment" "terraform-state-read-write" {
  role       = aws_iam_role.admin-role.name
  policy_arn = aws_iam_policy.terraform-state-rw.arn
}
