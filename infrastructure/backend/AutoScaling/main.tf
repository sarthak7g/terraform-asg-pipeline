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
  security_groups      = var.privateSecurityGroupId
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
  security_groups            = var.publicSecurityGroupId
  subnets                    = var.publicSubnet
  enable_deletion_protection = false
  tags = {
    "name" = "cryptern-backend-lb.${var.env}"
  }
}
resource "aws_lb_target_group" "backend-lb-tg" {
  count    = length(var.backendPorts)
  name     = "${element(var.appNames, count.index)}-backend-lb-tg-${var.env}"
  port     = element(var.backendPorts, count.index)
  protocol = var.protocolType
  vpc_id   = var.vpc
  health_check {
    port = element(var.healthCheckPorts, count.index)
    path = element(var.healthCheckPath, count.index)
  }
  tags = {
    "name" = "${element(var.appNames, count.index)}-backend-lb-tg-${var.env}"
  }
}
resource "aws_lb_listener" "backend-lb-tg-listener" {
  load_balancer_arn = aws_lb.backend-lb.arn
  port              = var.loadBalancerPort
  protocol          = var.protocolType
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = var.fixedResponseType
      message_body = var.fixedResponseMessage
      status_code  = var.fixedResponseStatus
    }
  }
  depends_on = [
    aws_lb.backend-lb
  ]
}
resource "aws_lb_listener_rule" "backend-lb-tg-listener-rule" {
  count        = length(var.hostNames)
  listener_arn = aws_lb_listener.backend-lb-tg-listener.arn

  action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.backend-lb-tg, count.index).arn
  }
  condition {
    host_header {
      values = [element(var.hostNames, count.index)]
    }
  }
  depends_on = [
    aws_lb_listener.backend-lb-tg-listener
  ]
}
resource "aws_autoscaling_group" "asg" {
  name                      = "asg-backend.${var.env}"
  max_size                  = var.maxSize
  min_size                  = var.minSize
  health_check_grace_period = var.healthCheckGracePeriod
  health_check_type         = var.healthCheckType
  launch_configuration      = aws_launch_configuration.launch-config-backend.name
  vpc_zone_identifier       = var.privateSubnet
  target_group_arns         = [for tg in aws_lb_target_group.backend-lb-tg : tg.arn]
  depends_on = [
    aws_launch_configuration.launch-config-backend,
    aws_lb_listener.backend-lb-tg-listener
  ]
  tags = [{
    "name" = "asg-backend.${var.env}"
  }]
}
resource "aws_autoscaling_policy" "asg-policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "asg-policy-backend.${var.env}"
  policy_type            = var.policyType
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefinedMetricType
    }
    target_value     = var.targetValue
    disable_scale_in = var.disableScaleIn
  }
}
