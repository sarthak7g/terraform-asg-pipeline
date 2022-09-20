/**
*
* INSTRUCTIONS BEFORE EXECUTION- 
*   1) FIND(CTRL+F) <project> AND REPLACE IT WITH YOUR PROJECT NAME.
*
*/



resource "aws_vpc" "<project>-vpc" {
  cidr_block = var.vpcCidrBlock
  tags = {
    "name" = "${var.project}-vpc.${var.env}"
  }
}
/*
  Here we are passing subnet cidrs as array because there can be multiple availability zones and hence mulitple cidr blocks for subnets
*/
resource "aws_subnet" "private" {
  count                   = length(var.privateSubnets)
  availability_zone       = var.availabilityZones[count.index]
  vpc_id                  = aws_vpc.<project>-vpc.id          
  cidr_block              = var.privateSubnets[count.index]
  map_public_ip_on_launch = false
  depends_on = [
    aws_vpc.<project>-vpc
  ]

  tags = {
    "name" = "${var.project}-private-subnet.${var.env}"
  }
}
/*
  Here we are passing subnet cidrs as array because there can be multiple availability zones and hence mulitple cidr blocks for subnets
*/
resource "aws_subnet" "public" {
  count                   = length(var.publicSubnets)
  availability_zone       = var.availabilityZones[count.index]
  vpc_id                  = aws_vpc.<project>-vpc.id
  cidr_block              = var.publicSubnets[count.index]
  map_public_ip_on_launch = true
  depends_on = [
    aws_vpc.<project>-vpc
  ]
  tags = {
    "name" = "${var.project}-public-subnet.${var.env}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.<project>-vpc.id
  depends_on = [
    aws_vpc.<project>-vpc
  ]
  tags = {
    name = "${var.project}-igw.${var.env}"
  }
}
resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    "name" = "${var.project}-nat-eip.${var.env}"
  }
}
resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  subnet_id         = element(aws_subnet.public, 0).id
  allocation_id     = aws_eip.nat-eip.id
  depends_on = [
    aws_subnet.public,
    aws_eip.nat-eip
  ]
  tags = {
    name = "${var.project}-nat.${var.env}"
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
  vpc_id = aws_vpc.<project>-vpc.id
  depends_on = [
    aws_vpc.<project>-vpc
  ]
  tags = {
    name = "${var.project}-public-route-table.${var.env}"
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
  vpc_id = aws_vpc.<project>-vpc.id
  depends_on = [
    aws_vpc.<project>-vpc
  ]
  tags = {
    name = "${var.project}-private-route-table.${var.env}"
  }
}
resource "aws_route" "private-nat-route" {
  count                  = length(var.privateSubnets)
  route_table_id         = element(aws_route_table.private-route-table, count.index).id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
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
resource "aws_security_group" "private-sg" {
  name   = "${var.project}-private-sg.${var.env}"
  vpc_id = aws_vpc.<project>-vpc.id
  depends_on = [
    aws_vpc.<project>-vpc,
    aws_security_group.public-sg
  ]
  egress = [{
    description      = "Allow all outbound traffic"
    prefix_list_ids  = []
    security_groups  = []
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }]
  ingress = [{
    description      = "Allow inbound traffic from only public security group"
    prefix_list_ids  = []
    security_groups  = [aws_security_group.public-sg.id]
    self             = true
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }]
  tags = {
    "name" = "${var.project}-private-sg.${var.env}"
  }
}
resource "aws_security_group" "public-sg" {
  name   = "${var.project}-public-sg.${var.env}"
  vpc_id = aws_vpc.<project>-vpc.id
  depends_on = [
    aws_vpc.<project>-vpc
  ]
  egress = [{
    description      = "Allow all outbound traffic"
    prefix_list_ids  = []
    security_groups  = []
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }]
  ingress = [{
    description      = "Allow all inbound traffic"
    prefix_list_ids  = []
    security_groups  = []
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    protocol         = "-1"
    self             = true
    to_port          = 0
  }]
  tags = {
    "name" = "${var.project}-public-sg.${var.env}"
  }
}

