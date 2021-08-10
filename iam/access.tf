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
resource "aws_iam_role" "instance-role" {
  name = "instance-role-${var.env}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })

  tags = {
    "name" = "instance-role-${var.env}"
  }
}
resource "aws_iam_policy" "s3-read" {
  name        = "s3-read-only-${var.env}"
  description = "Read only full access to s3"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : "*"
      }
    ]
  })

}
resource "aws_iam_role_policy_attachment" "s3-read" {
  role       = aws_iam_role.instance-role.name
  policy_arn = aws_iam_policy.s3-read.arn
}
resource "aws_iam_instance_profile" "instance-profile" {
  name = "instance-profile-${var.env}"
  role = aws_iam_role.instance-role.name
}
resource "aws_iam_policy" "parameters-read" {
  name        = "ParameterReadDecrypt.${var.env}"
  description = "Read and Decrypt Params from Parameter store"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ssm:DescribeParameters",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "ssm:GetParameters"
        ],
        "Resource" : [
          "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*_${var.env}",
          "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        ]
      }
    ]
  })

}
resource "aws_iam_role_policy_attachment" "parameters-read" {
  role       = aws_iam_role.instance-role.name
  policy_arn = aws_iam_policy.parameters-read.arn
}
resource "aws_iam_role" "codedeploy" {
  name = "codedeploy-role-${var.env}"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codedeploy.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}
resource "aws_iam_role" "codepipeline-backend-role" {
  name = "codepipeline-backend-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role" "codepipeline-frontend-role" {
  name = "codepipeline-frontend-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codepipeline-backend-policy" {

  name = "codepipeline-backend-policy-${var.env}"

  policy = jsonencode(
    {
      "Statement" : [
        {
          "Action" : [
            "codepipeline:*",
            "codedeploy:GetApplication",
            "codedeploy:BatchGetApplications",
            "codedeploy:GetDeploymentGroup",
            "codedeploy:BatchGetDeploymentGroups",
            "codedeploy:ListApplications",
            "codedeploy:ListDeploymentGroups",
            "s3:GetBucketPolicy",
            "s3:GetBucketVersioning",
            "s3:GetObjectVersion",
            "s3:ListAllMyBuckets",
            "s3:ListBucket",
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "s3:GetObject",
            "s3:CreateBucket",
            "s3:PutBucketPolicy"
          ],
          "Effect" : "Allow",
          "Resource" : ["arn:aws:s3::*:deployment-cryptern-backend-${var.env}", "arn:aws:s3::*:codepipeline-cryptern-backend-${var.env}"]
        },
      ],
      "Version" : "2012-10-17"
    }
  )
}
resource "aws_iam_policy" "codepipeline-frontend-policy" {

  name = "codepipeline-frontend-policy-${var.env}"

  policy = jsonencode(
    {
      "Statement" : [
        {
          "Action" : [
            "codepipeline:*",
            "codedeploy:GetApplication",
            "codedeploy:BatchGetApplications",
            "codedeploy:GetDeploymentGroup",
            "codedeploy:BatchGetDeploymentGroups",
            "codedeploy:ListApplications",
            "codedeploy:ListDeploymentGroups",
            "s3:GetBucketPolicy",
            "s3:GetBucketVersioning",
            "s3:GetObjectVersion",
            "s3:ListAllMyBuckets",
            "s3:ListBucket",
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "s3:GetObject",
            "s3:CreateBucket",
            "s3:PutBucketPolicy"
          ],
          "Effect" : "Allow",
          "Resource" : ["arn:aws:s3::*:deployment-cryptern-frontend-${var.env}", "arn:aws:s3::*:codepipeline-cryptern-frontend-${var.env}"]
        },
      ],
      "Version" : "2012-10-17"
    }
  )
}
resource "aws_iam_role_policy_attachment" "codepipeline-backend-policy-attachment" {
  role       = aws_iam_role.codepipeline-backend-role.name
  policy_arn = aws_iam_policy.codepipeline-backend-policy.arn
}
resource "aws_iam_role_policy_attachment" "codepipeline-frontend-policy-attachment" {
  role       = aws_iam_role.codepipeline-frontend-role.name
  policy_arn = aws_iam_policy.codepipeline-frontend-policy.arn
}
