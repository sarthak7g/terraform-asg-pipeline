module "cryptern-infra-frontend-autoscaling" {
  source                 = "../../../frontend/AutoScaling"
  env                    = "prd"
  region                 = "us-east-1"
  referenceInstanceAmi   = data.terraform_remote_state.cryptern-static-frontend-data.outputs.reference-instance-frontend.id
  privateSecurityGroupId = [data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id]
  instanceType           = "t3a.medium"
  instanceProfileName    = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  maxSize                = 10
  minSize                = 2
  healthCheckGracePeriod = 300
  healthCheckType        = "ELB"
  privateSubnet          = [for subnet in data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet : subnet.id]
  publicSubnet           = [for subnet in data.terraform_remote_state.cryptern-infra-data.outputs.public-subnet : subnet.id]
  vpc                    = data.terraform_remote_state.cryptern-infra-data.outputs.vpc
  protocolType           = "HTTP"
  frontendPorts           = [3000]
  appNames               = ["cryptern"]
  loadBalancerPort       = 80
  hostNames              = ["www.crypterns.com"]
  fixedResponseType      = "application/json"
  fixedResponseMessage   = "Success"
  fixedResponseStatus    = 200
  publicSecurityGroupId  = [data.terraform_remote_state.cryptern-infra-data.outputs.public-sg.id]
  healthCheckPath        = ["/"]
  healthCheckPorts       = [3000]
  policyType             = "TargetTrackingScaling"
  predefinedMetricType   = "ASGAverageCPUUtilization"
  targetValue            = 80.0
  disableScaleIn         = false

}
