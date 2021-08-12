module "cryptern-infra-backend-autoscaling" {
  source                 = "../../../backend/AutoScaling"
  env                    = "dev"
  region                 = "us-east-1"
  referenceInstanceAmi   = data.terraform_remote_state.cryptern-static-backend-data.outputs.reference-instance-backend.id
  privateSecurityGroupId = [data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id]
  instanceType           = "t2.small"
  instanceProfileName    = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  maxSize                = 2
  minSize                = 1
  healthCheckGracePeriod = 300
  healthCheckType        = "EC2"
  privateSubnet          = [for subnet in data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet : subnet.id]
  publicSubnet           = [for subnet in data.terraform_remote_state.cryptern-infra-data.outputs.public-subnet : subnet.id]
  vpc                    = data.terraform_remote_state.cryptern-infra-data.outputs.vpc
  protocolType           = "HTTP"
  backendPorts           = [3000, 3002]
  appNames               = ["api", "socket"]
  loadBalancerPort       = 80
  hostNames              = ["cryptern-api-dev.primathon.in", "crypterns-socket.primathon.in"]
  fixedResponseType      = "application/json"
  fixedResponseMessage   = "Success"
  fixedResponseStatus    = 200
  publicSecurityGroupId  = [data.terraform_remote_state.cryptern-infra-data.outputs.public-sg.id]
  healthCheckPath        = ["/api", "/api"]
  healthCheckPorts       = [3000, 3000]
  policyType             = "TargetTrackingScaling"
  predefinedMetricType   = "ASGAverageCPUUtilization"
  targetValue            = 75.0
  disableScaleIn         = false

}
