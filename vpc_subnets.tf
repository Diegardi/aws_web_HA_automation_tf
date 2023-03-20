#Vpc
resource "aws_vpc" "training_vpc" {
  cidr_block = var.training_vpc

  tags = {
    Name = "VPC_DG"
  }
}

#Public Subnets
resource "aws_subnet" "public_subnet" {
  count             = var.training_vpc == "10.0.0.0/16" ? 2 : 0
  vpc_id            = aws_vpc.training_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = element(cidrsubnets(var.training_vpc, 8, 4), count.index)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Public_Subnet_DG_${count.index}"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.training_vpc.id
  tags = {
    Name = "Internet_Gateway_DG"
  }
}

#Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.training_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}

#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "public_rt_association" {
  count                   = length(aws_subnet.public_subnet) == 2 ? 2 : 0
  route_table_id          = aws_route_table.public_route_table.id
  subnet_id               = element(aws_subnet.public_subnet.*.id, count.index)
}