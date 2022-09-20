/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <project-domain> WITH YOUR PROJECT DOMAIN NAME
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
*/ 
module "<project>-infra-frontend-autoscaling" {
  project                = "<project>"
  source                 = "../../../frontend/AutoScaling"
  env                    = "<env>"
  region                 = "us-east-1"
  referenceInstanceAmi   = data.terraform_remote_state.<project>-static-frontend-data.outputs.reference-instance-frontend.id
  privateSecurityGroupId = [data.terraform_remote_state.<project>-infra-data.outputs.private-sg.id]
  instanceType           = "t3a.medium"
  instanceProfileName    = data.terraform_remote_state.<project>-iam-data.outputs.instance-profile.name
  maxSize                = 10
  minSize                = 2
  healthCheckGracePeriod = 300
  healthCheckType        = "ELB"
  privateSubnet          = [for subnet in data.terraform_remote_state.<project>-infra-data.outputs.private-subnet : subnet.id]
  publicSubnet           = [for subnet in data.terraform_remote_state.<project>-infra-data.outputs.public-subnet : subnet.id]
  vpc                    = data.terraform_remote_state.<project>-infra-data.outputs.vpc
  protocolType           = "HTTP"
  frontendPorts           = [3000]
  appNames               = ["<project>"]
  loadBalancerPort       = 80
  hostNames              = ["www.<project-domain>.com"]
  fixedResponseType      = "application/json"
  fixedResponseMessage   = "Success"
  fixedResponseStatus    = 200
  publicSecurityGroupId  = [data.terraform_remote_state.<project>-infra-data.outputs.public-sg.id]
  healthCheckPath        = ["/"]
  healthCheckPorts       = [3000]
  policyType             = "TargetTrackingScaling"
  predefinedMetricType   = "ASGAverageCPUUtilization"
  targetValue            = 80.0
  disableScaleIn         = false

}
