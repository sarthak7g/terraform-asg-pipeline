module "cryptern-infra-backend-static" {
  source                = "../../../backend/Static"
  env                   = "dev"
  region                = "us-east-1"
  referenceInstanceType = "t2.small"
  securityGroupId       = data.terraform_remote_state.cryptern-infra-data.outputs.private-sg.id
  privateSubnet         = data.terraform_remote_state.cryptern-infra-data.outputs.private-subnet
  amiId                 = data.terraform_remote_state.cryptern-infra-data.outputs.ubuntu_ami.id
  instanceProfileName   = data.terraform_remote_state.cryptern-iam-data.outputs.instance-profile.name
  jumpServerPublicKey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnDq8nSyY0qBHtQQw7nnulQk0C7L/bGjUf5L6uA3kz6t2pEbJUtTe/O/sxxr5+TOPkSFNuSRJqi6VHTAteUsLwp0OGH5bl9aB4ZdrE+itw2Xix+78gQ6lpeFOrEvULjRplFqaLzkETisPzSBKRaFeBrnhOdZ2vZLYfmCVTL3P1w5BQA/Tp4iL6vn+WehcYAWahoxy287/2ym1ua10Rx8BxHeaeEIt1BzoznxRMqlmVF/zl8wkxLqak0gD0goGv4JxrYl8S4iDgztzW9RX5pcyHguDf5HxkFR0fbbxNYYkIiB4l1ASXDcuLLXPQ9uoY6DPvxveUhTIhUpCgLdfoaLojSSkWQlV1I2AN6KbQiWAj8dXYWdaSEFkYr0zV7l30cyv8yszFSm3uC1304oOGHAmxjA4igP9bVPggl6wz0mtg/N9Nv0mctIIeG1ox5qT6Qzz2KEmb0uGd2Ua6oyhQgGoo0CzLJubS3h9Y0rxNe3RwMDKGzkWB0nxoDsEFM6J1L5k= ubuntu@ip-10-0-1-205"
}
