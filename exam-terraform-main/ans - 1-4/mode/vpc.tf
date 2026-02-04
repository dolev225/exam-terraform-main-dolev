data "aws_availability_zones" "available" {
  state = "available"
}

# create vpc 
resource "aws_vpc" "example" {
  cidr_block = var.vpc_range
}

# create the subnet and connect to vpc
resource "aws_subnet" "Public-Subnet" {
  count      = var.Subnet_count
  vpc_id     = aws_vpc.example.id
  cidr_block = cidrsubnet(var.vpc_range, 8, count.index)
  map_public_ip_on_launch = var.if_Public_ip
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}
resource "aws_subnet" "Private-Subnet" {
  count      = var.Subnet_count
  vpc_id                  = aws_vpc.example.id
  cidr_block = cidrsubnet(var.vpc_range, 8, count.index + 100)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

# create igw and connect to vpc
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "igw"
  }
}
# create a route table -Public
resource "aws_route_table" "rt_Public" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
# create a route table -Private
resource "aws_route_table" "rt_Private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "con-Public-rt" {
  count          = var.Subnet_count
  subnet_id      = aws_subnet.Public-Subnet[count.index].id 
  route_table_id = aws_route_table.rt_Public.id
}

# connect the route table to the subnet
resource "aws_route_table_association" "con-Private-rt" {
  count          = var.Subnet_count
  subnet_id      = aws_subnet.Private-Subnet[count.index].id 
  route_table_id = aws_route_table.rt_Private.id
}

#  create a security group
resource "aws_security_group" "sg" {
  name   = "sg_dolev"
  vpc_id = aws_vpc.example.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}