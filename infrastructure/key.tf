resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key.${var.env}"
  public_key = file("${var.publicKeyFileLocation}")
  tags = {
    "name" = "deployer-key.${var.env}"
  }
}
