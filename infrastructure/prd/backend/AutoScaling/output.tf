output "reference-instance-image-backend" {
  value = module.cryptern-infra-backend-autoscaling.reference-instance-image-backend
}
output "asg" {
  value = module.cryptern-infra-backend-autoscaling.asg
}
output "targetGroup" {
  value = module.cryptern-infra-backend-autoscaling.targetGroup
}
