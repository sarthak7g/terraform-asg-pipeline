resource "aws_ami_from_instance" "reference-instance-image-backend" {
  name               = "reference-instance-image-backend.${var.env}"
  source_instance_id = var.referenceInstanceAmi
  tags = {
    "name" = "reference-ami-${var.env}"
  }
}
resource "aws_launch_configuration" "launch-config-backend" {
  image_id             = aws_ami_from_instance.reference-instance-image-backend.id
  instance_type        = var.instanceType
  security_groups      = var.securityGroupId
  name                 = "launch-config-backend.${var.env}"
  iam_instance_profile = var.instanceProfileName
  depends_on = [
    aws_ami_from_instance.reference-instance-image-backend
  ]
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb" "backend-lb" {
  name                       = "cryptern-backend-lb-${var.env}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.securityGroupId
  subnets                    = var.publicSubnet
  enable_deletion_protection = true
  tags = {
    "name" = "cryptern-backend-lb.${var.env}"
  }
}
resource "aws_lb_target_group" "backend-lb-tg" {
  name     = "backend-lb-tg-${var.env}"
  port     = var.port
  protocol = var.protocolType
  vpc_id   = var.vpc

}
resource "aws_lb_listener" "backend-lb-tg-listener" {
  load_balancer_arn = aws_lb.backend-lb.arn
  port              = var.loadBalancerPort
  protocol          = var.protocolType
  depends_on = [
    aws_lb.backend-lb,
    aws_lb_target_group.backend-lb-tg
  ]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-lb-tg.arn
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "asg-backend.${var.env}"
  max_size                  = var.maxSize
  min_size                  = var.minSize
  health_check_grace_period = var.healthCheckGracePeriod
  health_check_type         = var.healthCheckType
  launch_configuration      = aws_launch_configuration.launch-config-backend.name
  vpc_zone_identifier       = var.privateSubnet
  target_group_arns         = [aws_lb_target_group.backend-lb-tg.arn]
  depends_on = [
    aws_launch_configuration.launch-config-backend,
    aws_lb_listener.backend-lb-tg-listener
  ]
  tags = [{
    "name" = "asg-backend.${var.env}"
  }]
}
