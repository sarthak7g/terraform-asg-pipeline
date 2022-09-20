resource "aws_instance" "jump-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jumpServerInstanceType
  subnet_id              = element(aws_subnet.public, 0).id
  vpc_security_group_ids = [aws_security_group.public-sg.id]
  key_name               = aws_key_pair.deployer.key_name
  depends_on = [
    aws_key_pair.deployer
  ]
  tags = {
    "name" = "${var.project}-jump-server.${var.env}"
  }
}