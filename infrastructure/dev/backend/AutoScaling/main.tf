module "cryptern-infra-backend-autoscaling" {
  source                 = "../../../backend/AutoScaling"
  env                    = "dev"
  region                 = "us-east-1"
  referenceInstanceAmi   = data.terraform_remote_state.cryptern-static-backend-data.outputs.reference-instance-backend.id
  securityGroupId        = [data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id]
  instanceType           = "t2.micro"
  instanceProfileName    = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  maxSize                = 2
  minSize                = 1
  healthCheckGracePeriod = 300
  healthCheckType        = "ELB"
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
}
