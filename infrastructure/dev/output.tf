output "ubuntu_ami" {
  value = module.cryptern-infra.ubuntu_ami
}

output "private-sg" {
  value = module.cryptern-infra.private-sg
}
output "private-subnet" {
  value = module.cryptern-infra.private-subnet
}
