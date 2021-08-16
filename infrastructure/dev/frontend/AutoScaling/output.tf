output "reference-instance-image-frontend" {
  value = module.cryptern-infra-frontend-autoscaling.reference-instance-image-frontend
}
output "asg" {
  value = module.cryptern-infra-frontend-autoscaling.asg
}
output "targetGroup" {
  value = module.cryptern-infra-frontend-autoscaling.targetGroup
}
