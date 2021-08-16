module "cryptern-infra-frontend-static" {
  source                = "../../../frontend/Static"
  env                   = "dev"
  region                = "us-east-1"
  referenceInstanceType = "t2.small"
  securityGroupId       = data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id
  privateSubnet         = data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet
  amiId                 = data.terraform_remote_state.cryptern-infra-data.outputs.ubuntu_ami.id
  instanceProfileName   = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  jumpServerPublicKey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsL2XAJfra531cVVOR6OEnRau45prYS9cnuxj+cJv9gP7wEZ74EoLbveLiOD4sNRfW2q+Y3OXep02uj4ugZnLDP54nC4eCm3shpWVg/Y48rVMz74pZpu9+RUwSCo+HdoVwbmzuZbtTdaOZ5PJhyB6qXj8oUwHDpLcC4z2UINO1wRqftskoohpai+5qwifDbwFGw+rPL80zfAAVV2YmpoT2ooDHbOXa2jbJlVJjE6mKSpRbWfvtjCjCqvk6av7Nnuxn5BWznLCfBEwH4To471VV13j6BRTmFYoeFxesT55OQR2aHw1plEFnzo6Zpk/+iZieJccyXoMK1/RSPPzY4JzQLgVBn3NS9ndqfpmdFjjz1nVbn+ImMbYGjFN/8fDMUZcSByNTOsCBrYyLqO6B9MvL9KkztbxSFsgNR+atL3n7jYZHZXuRAme+3Kn6pG1xMzgAQZvWcbtF/8wK1e8+5bImKLeSSxMXCRo6RYPtO/yGPKcEzpxi8yf15qp8/oLaXnc= ubuntu@ip-10-0-1-198"
  part                  = "frontend"
}
