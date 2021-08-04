resource "aws_ami_from_instance" "reference-instance-image" {
  name               = "reference-instance-image.${var.env}"
  source_instance_id = var.referenceInstanceAmi
  tags = {
    "name" = "reference-ami-${var.env}"
  }
}
resource "aws_launch_configuration" "launch-config-backend" {
  image_id             = aws_ami_from_instance.reference-instance-image.id
  instance_type        = var.instanceType
  security_groups      = var.securityGroupId
  name                 = "launch-config-backend.${var.env}"
  iam_instance_profile = var.instanceProfileName

  lifecycle {
    create_before_destroy = true
  }
}
