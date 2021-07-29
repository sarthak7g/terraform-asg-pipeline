resource "aws_instance" "reference-instance-backend" {
  ami                    = var.amiId
  instance_type          = var.referenceInstanceType
  subnet_id              = element(var.privateSubnet, 0).id
  vpc_security_group_ids = [var.securityGroupId]
  key_name               = aws_key_pair.reference-backend.key_name
  iam_instance_profile   = var.instanceProfileName
  user_data              = file("${path.module}/userData.sh")
  depends_on = [
    aws_key_pair.reference-backend
  ]
  tags = {
    "name" = "cryptern-reference-instance-backend.${var.env}"
  }
}
