output "ubuntu_ami" {
  value = data.aws_ami.ubuntu
}

output "private-sg" {
  value = aws_security_group.private-sg
}
output "private-subnet" {
  value = aws_subnet.private
}
