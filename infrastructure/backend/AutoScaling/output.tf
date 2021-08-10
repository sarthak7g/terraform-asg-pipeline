output "reference-instance-image-backend" {
  value = aws_ami_from_instance.reference-instance-image-backend.id
}
output "asg" {
  value = aws_autoscaling_group.asg
}
output "targetGroup" {
  value = aws_lb_target_group.backend-lb-tg
}
