module "cryptern-infra-backend-static" {
  source                = "../../../backend/Static"
  env                   = "prd"
  region                = "us-east-1"
  referenceInstanceType = "t2.small"
  securityGroupId       = data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id
  privateSubnet         = data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet
  amiId                 = data.terraform_remote_state.cryptern-infra-data.outputs.ubuntu_ami.id
  instanceProfileName   = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  jumpServerPublicKey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6j2CAJFTipKXRQhdOBb2bQGgJHiP+Qdw2rF1s6H+AIeMMCGXJ0R1CLn6aK83rOBLnNpgUjEhGDFTuH91kV9iZCuBe5sXZgB5mf0nB1X2oPhFhZK6hrsFyhGr/mkG9QQQQFwuC09dCF9vYVwrUxQ/vQTfHvKNoLt5nNVQrgapXlTKWg+6ySSVwm59ZsK0UAUpE8RuVse6cknWDyTE8QoZRGLUemlKCAd3b/s86UoWAzy3EGLdYsh4AcuF99USNNC5blL60ik33KRCqGg4yBFVYGeR93VXOhC5WEvX1CIbzCoyLjEbfno3jgVU+Cs21n3TcxxxR/xr/ThEPhkJY/UuKDAT7yxAZ1++x9ng4KpReeKAQ+lJWM8GtdX8YRRrKzf0mKYYo4J0ljTLNBJlN+e1O1vwczS5EHgwV6XUVM5NodPD/zGTSdKSIGIZSwbA8yQAsNTlAQYKXjRkYfdbpKmi0V+vjuh/kmEQRyRQrNNWBpeLxz3I5OnI8UPPTKjdHqF8= ubuntu@ip-20-0-1-156"
  part                  = "backend"
  redisNodeType         = "cache.t3.small"
}
