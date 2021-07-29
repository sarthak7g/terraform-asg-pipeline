resource "aws_key_pair" "reference-backend" {
  key_name   = "reference-backend-key.${var.env}"
  public_key = var.jumpServerPublicKey
  tags = {
    "name" = "reference-backend-key.${var.env}"
  } 
}
