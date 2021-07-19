resource "aws_vpc" "cryptern-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "cryptern-vpc.${var.env}"
  }
}
resource "aws_subnet" "private" {
  count                   = length(var.privateSubnets)
  vpc_id                  = aws_vpc.cryptern-vpc.id
  cidr_block              = var.privateSubnets[count.index]
  map_public_ip_on_launch = false

  tags = {
    "name" = "cryptern-public-subnet.${var.env}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.publicSubnets)
  vpc_id                  = aws_vpc.cryptern-vpc.id
  cidr_block              = var.publicSubnets[count.index]
  map_public_ip_on_launch = true

  tags = {
    "name" = "cryptern-public-subnet.${var.env}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cryptern-vpc.id

  tags = {
    name = "cryptern-igw.${var.env}"
  }
}
resource "aws_nat_gateway" "nat" {
  count             = length(var.privateSubnets)
  connectivity_type = "private"
  subnet_id         = element(aws_subnet.private, count.index).id
  tags = {
    name = "cryptern-nat.${var.env}"
  }
}

/*
Subnet -- Is a set of IP addresses
Public subnet --- For which we have exposed to internet
Private subnet ---- For which we have protected from internet
Route Table --- is associated with a particular subnet


Public subnet  ----- its route tabel ---- public route table   Destination ---10.0.0.0/16 local routing Destination ---- 0.0.0.0/0 Internet gateway routing
private subnet  ----- its route tabel ---- private route table   Destination ---10.0.0.0/16 local routing Destination ---- 0.0.0.0/0 NAT gateway routing 
*/
resource "aws_route_table" "public-route-table" {
  count  = length(var.publicSubnets)
  vpc_id = aws_vpc.cryptern-vpc.id

  tags = {
    name = "cryptern-public-route-table.${var.env}"
  }
}
resource "aws_route" "public-igw-route" {
  count                  = length(var.publicSubnets)
  route_table_id         = element(aws_route_table.public-route-table, count.index).id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.public-route-table]
}
/*
 
Making public subnet Internet facing by associating route table to subnet 
*/
resource "aws_route_table_association" "public-subnet-route-table" {
  count          = length(var.publicSubnets)
  subnet_id      = element(aws_subnet.public, count.index).id
  route_table_id = element(aws_route_table.public-route-table, count.index).id
}
resource "aws_route_table" "private-route-table" {
  count  = length(var.privateSubnets)
  vpc_id = aws_vpc.cryptern-vpc.id

  tags = {
    name = "cryptern-private-route-table.${var.env}"
  }
}
resource "aws_route" "private-nat-route" {
  count                  = length(var.privateSubnets)
  route_table_id         = element(aws_route_table.private-route-table, count.index).id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat, count.index).id
  depends_on             = [aws_route_table.private-route-table]
}
/*
Making private subnet Internet facing by associating route table to subnet 
*/
resource "aws_route_table_association" "private-subnet-route-table" {
  count          = length(var.privateSubnets)
  subnet_id      = element(aws_subnet.private, count.index).id
  route_table_id = element(aws_route_table.private-route-table, count.index).id
}

