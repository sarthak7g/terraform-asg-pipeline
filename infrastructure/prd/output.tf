/*
* REPLACE <project> WITH YOUR PROJECT NAME
*/ 

output "ubuntu_ami" {
  value = module.<project>-infra.ubuntu_ami
}

output "private-sg" {
  value = module.<project>-infra.private-sg
}
output "private-subnet" {
  value = module.<project>-infra.private-subnet
}
output "vpc" {
  value = module.<project>-infra.vpc
}
output "public-subnet" {
  value = module.<project>-infra.public-subnet
}
output "public-sg" {
  value = module.<project>-infra.public-sg
}