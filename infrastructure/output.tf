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
  value = aws_vpc.<project>-vpc.id  // REPLACE <project> WITH YOUR PROJECT NAME
}
output "public-subnet" {
  value = aws_subnet.public
}
output "public-sg" {
  value = aws_security_group.public-sg
}