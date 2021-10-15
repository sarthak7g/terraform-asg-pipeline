module "cryptern-infra-frontend-static" {
  source                = "../../../frontend/Static"
  env                   = "stg"
  region                = "us-east-1"
  referenceInstanceType = "t3a.medium"
  securityGroupId       = data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id
  privateSubnet         = data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet
  amiId                 = data.terraform_remote_state.cryptern-infra-data.outputs.ubuntu_ami.id
  instanceProfileName   = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  jumpServerPublicKey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB2HhqZwnY+xEI+ys3YvJhHu/sWWq9jXPPr+j5HJr2D908M3DpHpaZT/tCRIzNrMim2UjES0LIg+ZBxNbENcQR6uuKehtkV6exIcxSy4/rsF+EdNkrOBwQNku8pp4d4vog+xznGXYnjyicfiIZvm3IW8+Qb0i+Uo6jtwOWBmt7oeao92izqThCnHUgGmgecv2l8d91RlRsfNiPGJxhUuikv8SDsGkqtvqJhBHbgKCTZSZgwTrp2txYybVF6CCJG2L68nXK4Li/srsXX19f+9IvfJuXv6GPc0KjfFVYiQ4WrLfSkTKZzVFrMHiacZ0EplQXCFgrq/tlIPxd3FZr3XMhhep1GzMuhi/ylK13ks1TVLzpXitrFszC5j0MoLUNsyUU1zQQFR1DRVQNye35fNexz9kG6bm33sKwmc90FmF71EjIviLJYQ1OY8V0HV+QlLEgoXYIHVVifV2f3NiXdz0tKE94xDoEeZ0o/VfY8Z82863JYuZ43NzMvrF1vIGNdTM= ubuntu@ip-20-0-1-16"
  part                  = "frontend"
  indexDocument         = "index.html"
  cmsSite               = "www.cms-crypterns-stg.primathon.in"
}
