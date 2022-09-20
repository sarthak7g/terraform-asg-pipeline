/*
* REPLACE <project> WITH YOUR PROJECT NAME
*/ 
output "reference-instance-image-frontend" {
  value = module.<project>-infra-frontend-autoscaling.reference-instance-image-frontend
}
output "asg" {
  value = module.<project>-infra-frontend-autoscaling.asg
}
output "targetGroup" {
  value = module.<project>-infra-frontend-autoscaling.targetGroup
}
