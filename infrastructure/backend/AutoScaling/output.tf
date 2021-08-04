output "reference-instance-backend-ami" {
  value = aws_ami_from_instance.reference-instance-image.id
}
