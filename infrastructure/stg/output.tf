output "ubuntu_ami" {
  value = module.cryptern-infra.ubuntu_ami
}

output "private-sg" {
  value = module.cryptern-infra.private-sg
}
output "private-subnet" {
  value = module.cryptern-infra.private-subnet
}
output "vpc" {
  value = module.cryptern-infra.vpc
}
output "public-subnet" {
  value = module.cryptern-infra.public-subnet
}
output "public-sg" {
  value = module.cryptern-infra.public-sg
}