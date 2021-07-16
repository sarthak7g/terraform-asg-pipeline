resource "aws_s3_bucket" "tf-state-storage" {
  bucket = "tf-remote-state.cryptern.${var.env}"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_public_access_block" "tf-state-storage" {
  bucket = aws_s3_bucket.tf-state-storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "tf-remote-state-lock.cryptern.${var.env}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
# resource "aws_iam_user_policy_attachment" "remote_state_access" {
#   user       = aws_iam_user.terraform.name
#   policy_arn = module.remote_state.terraform_iam_policy.arn
# }
