resource "aws_vpc" "cryptern-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "cryptern-vpc.${var.env}"
  }
}
# resource "aws_subnet" "private" {
#   count                   = length(var.privateSubnets)
#   vpc_id                  = aws_vpc.cryptern-vpc.id
#   cidr_block              = var.privateSubnets[count.index]
#   availability_zone       = var.availabilityZones[count.index]
#   map_public_ip_on_launch = false

#   tags = {
#     "name" = "cryptern-public-subnet.${var.env}"
#   }
# }

# resource "aws_subnet" "public" {
#   count                   = length(var.publicSubnets)
#   vpc_id                  = aws_vpc.cryptern-vpc.id
#   cidr_block              = var.publicSubnets[count.index]
#   availability_zone       = var.availabilityZones[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     "name" = "cryptern-public-subnet.${var.env}"
#   }
# }
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.cryptern-vpc.id

#   tags = {
#     name = "cryptern-igw.${var.env}"
#   }
# }
# resource "aws_nat_gateway" "nat" {
#   connectivity_type = "private"
#   subnet_id         = element()
# }
