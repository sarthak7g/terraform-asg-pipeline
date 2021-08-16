resource "aws_key_pair" "reference-frontend" {
  key_name   = "reference-frontend-key.${var.env}"
  public_key = var.jumpServerPublicKey
  tags = {
    "name" = "reference-frontend-key.${var.env}"
  }
}
