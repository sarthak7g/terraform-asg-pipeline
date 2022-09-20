/*
* REPLACE <project> WITH YOUR PROJECT NAME
*/ 
resource "aws_s3_bucket" "<project>-data-bucket" {
  bucket = "data-${var.project}-${var.part}-${var.env}"
  versioning {
    enabled = true
  }
  tags = {
    "name" = "data-${var.project}-${var.part}-${var.env}"
  }
}
resource "aws_s3_bucket_policy" "data-bucket-policy" {
  bucket = aws_s3_bucket.<project>-data-bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject", "s3:GetObjectVersion"],
        "Resource" : [aws_s3_bucket.<project>-data-bucket.arn, "${aws_s3_bucket.<project>-data-bucket.arn}/*"]
      },
      {
        "Sid" : "FullAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${data.aws_iam_user.backend-api-user.user_name}"]
        },
        "Action" : "s3:*",
        "Resource" : ["${aws_s3_bucket.<project>-data-bucket.arn}/*", "${aws_s3_bucket.<project>-data-bucket.arn}"],
      }
    ]
  })
}
