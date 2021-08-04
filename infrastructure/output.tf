output "ubuntu_ami" {
  value = data.aws_ami.ubuntu
}

output "private-sg" {
  value = aws_security_group.private-sg
}
output "private-subnet" {
  value = aws_subnet.private
}
output "vpc" {
  value = aws_vpc.cryptern-vpc.id
}
output "public-subnet" {
  value = aws_subnet.public
}
