/*
* REPLACE <project> WITH YOUR PROJECT NAME
*/ 
resource "aws_s3_bucket" "www-cms-<project>-bucket" {
  bucket = "${var.cmsSite}"
  website {
    index_document = var.indexDocument
  }
  tags = {
    "name" = "${var.cmsSite}"
  }
}
resource "aws_s3_bucket_public_access_block" "www-cms-<project>-bucket" {
  bucket = aws_s3_bucket.www-cms-<project>-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "www-cms-<project>-bucket-policy" {
  bucket = "${var.cmsSite}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject", "s3:GetObjectVersion"],
        "Resource" : [aws_s3_bucket.www-cms-<project>-bucket.arn, "${aws_s3_bucket.www-cms-<project>-bucket.arn}/*"]
      },
      {
        "Sid" : "FullAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${data.aws_iam_user.gitlab.user_name}"]
        },
        "Action" : "s3:*",
        "Resource" : [aws_s3_bucket.www-cms-<project>-bucket.arn, "${aws_s3_bucket.www-cms-<project>-bucket.arn}/*"],
      }
    ]
  })
}
resource "aws_s3_bucket" "cms-<project>-bucket" {
  bucket = "${var.cmsSite}"
  website {
    index_document = var.indexDocument
  }
  tags = {
    "name" = "${var.cmsSite}"
  }
}
resource "aws_s3_bucket_public_access_block" "cms-<project>-bucket" {
  bucket = aws_s3_bucket.cms-<project>-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "cms-<project>-bucket-policy" {
  bucket = "${var.cmsSite}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject", "s3:GetObjectVersion"],
        "Resource" : [aws_s3_bucket.cms-<project>-bucket.arn, "${aws_s3_bucket.cms-<project>-bucket.arn}/*"]
      },
      {
        "Sid" : "FullAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${data.aws_iam_user.gitlab.user_name}"]
        },
        "Action" : "s3:*",
        "Resource" : [aws_s3_bucket.cms-<project>-bucket.arn, "${aws_s3_bucket.cms-<project>-bucket.arn}/*"],
      }
    ]
  })
}
