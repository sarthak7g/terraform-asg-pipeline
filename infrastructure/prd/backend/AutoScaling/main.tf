/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
* REPLACE HOSTNAMES
*/ 
module "<project>-infra-backend-autoscaling" {
  project                = "<project>"
  source                 = "../../../backend/AutoScaling"
  env                    = "<env>"
  region                 = "us-east-1"
  referenceInstanceAmi   = data.terraform_remote_state.<project>-static-backend-data.outputs.reference-instance-backend.id
  privateSecurityGroupId = [data.terraform_remote_state.<project>-infra-data.outputs.private-sg.id]
  instanceType           = ["t3a.medium","t3a.large"]
  instanceProfileName    = data.terraform_remote_state.<project>-iam-data.outputs.instance-profile.name
  maxSize                = 10
  minSize                = 4
  healthCheckGracePeriod = 300
  healthCheckType        = "ELB"
  privateSubnet          = [for subnet in data.terraform_remote_state.<project>-infra-data.outputs.private-subnet : subnet.id]
  publicSubnet           = [for subnet in data.terraform_remote_state.<project>-infra-data.outputs.public-subnet : subnet.id]
  vpc                    = data.terraform_remote_state.<project>-infra-data.outputs.vpc
  protocolType           = "HTTP"
  backendPorts           = [80]
  appNames               = ["<project>"]
  loadBalancerPort       = 80
  hostNames              = ["api.crypterns.com", "chat.crypterns.com"] // REPLACE THESE HOSTNAMES WITH YOURS
  fixedResponseType      = "application/json"
  fixedResponseMessage   = "Success"
  fixedResponseStatus    = 200
  publicSecurityGroupId  = [data.terraform_remote_state.<project>-infra-data.outputs.public-sg.id]
  healthCheckPath        = ["/"]
  healthCheckPorts       = [80]
  policyType             = "TargetTrackingScaling"
  predefinedMetricType   = "ASGAverageCPUUtilization"
  targetValue            = 80.0
  disableScaleIn         = false
  stickinessTime         = 3600
}
