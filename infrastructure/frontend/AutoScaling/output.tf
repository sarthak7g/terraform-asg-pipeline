output "reference-instance-image-frontend" {
  value = aws_ami_from_instance.reference-instance-image-frontend.id
}
output "asg" {
  value = aws_autoscaling_group.asg
}
output "targetGroup" {
  value = aws_lb_target_group.frontend-lb-tg
}
