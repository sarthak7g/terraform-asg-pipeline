/*
* REPLACE <project> WITH YOUR PROJECT NAME
*/ 
output "reference-instance-image-backend" {
  value = module.<project>-infra-backend-autoscaling.reference-instance-image-backend
}
output "asg" {
  value = module.<project>-infra-backend-autoscaling.asg
}
output "targetGroup" {
  value = module.<project>-infra-backend-autoscaling.targetGroup
}
