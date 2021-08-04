resource "aws_ami_from_instance" "reference-instance-image" {
  name               = "reference-instance-image.${var.env}"
  source_instance_id = var.referenceInstanceAmi
}