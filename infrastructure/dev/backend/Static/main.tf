module "cryptern-infra-backend-static" {
  source                = "../../../backend/Static"
  env                   = "dev"
  region                = "us-east-1"
  referenceInstanceType = "t2.small"
  securityGroupId       = data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id
  privateSubnet         = data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet
  amiId                 = data.terraform_remote_state.cryptern-infra-data.outputs.ubuntu_ami.id
  instanceProfileName   = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  jumpServerPublicKey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoYNNywT8Dg8o9Wlbb9m78ZUHPXlrSD/fumN1t/bcZg1wmdm/qZMxKX0PQJYP7J1ZZBwCWSQjjtc1vbIQerzt4gFff2RhPfSjVW05CzprPg7Wr9vEnFGISvhV/ukW2izgb/1UrkQf4DIeSlsEz2J0w0MdD5811VbwRh+136wLRCDiMyAlBmOzAI0iH176OHHf0ubVdzg9jP66e9U0C6uj5oJkF4TWqIxwaoyqTVzkHjIcueSInkJDSUEAriqySHLXSrpUQleUlOPwL6vEoh3FM1U/qT9taa9i5Qabmn1FQ0kF5eNKAHLJ7WfLDaSNKpxFi23UOB7PWO6HnAgPN5COTx4l1TnatUow6HUab0WLg//WsuiFmxFsvc+F0tsJZITTpGBm+A29MLLSd6WS0Pn3E6gk6RUzC/YlajajwKlgwoOiBBDkek1JkKhs7aRizdOdh6Cn/TyaT4dmOKx26EDdFdbP2pittjYgimvxgYIJpoRFgSOPn+0gCzXlI1QEuRrk= ubuntu@ip-10-0-1-226"
  part                  = "backend"
}
