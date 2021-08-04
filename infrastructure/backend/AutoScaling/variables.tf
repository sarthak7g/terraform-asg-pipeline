variable "env" {

}

variable "region" {

}
variable "referenceInstanceAmi" {

}
variable "securityGroupId" {
  type = list(string)
}
variable "instanceType" {

}
variable "instanceProfileName" {

}
variable "maxSize" {
  type = number
}
variable "minSize" {
  type = number
}
variable "healthCheckGracePeriod" {
  type = number
}
variable "healthCheckType" {

}
variable "privateSubnet" {
  type = list(string)
}
variable "publicSubnet" {
  type = list(string)
}
variable "vpc" {

}
variable "protocolType" {

}
variable "port" {
  description = "Port on which targets receive traffic"
}
variable "loadBalancerPort" {
  description = "Port on which the load balancer is listening. Not valid for Gateway Load Balancers."
}
