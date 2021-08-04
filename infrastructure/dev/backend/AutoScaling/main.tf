module "cryptern-infra-backend-autoscaling" {
  source               = "../../../backend/AutoScaling"
  env                  = "dev"
  region               = "us-east-1"
  referenceInstanceAmi = data.terraform_remote_state.cryptern-static-backend-data.outputs.reference-instance-backend.id
  securityGroupId      = [data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id]
  instanceType         = "t2.micro"
  instanceProfileName  = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
}
