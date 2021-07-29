resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key.${var.env}"
  public_key = var.publicKey
  tags = {
    "name" = "deployer-key.${var.env}"
  }
}
