
# create the vpc
resource "aws_vpc" "terraform-task-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "${terraform.workspace}-task-vpc"
  }
}

# get all the availability zones are available in this region
data "aws_availability_zones" "AZs" {
  state = "available"
}

# create subnets (public and private)
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.terraform-task-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.AZs.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${terraform.workspace}-10.0.1.0/24-${data.aws_availability_zones.AZs.names[0]}"
  }
}
resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.terraform-task-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.AZs.names[0]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${terraform.workspace}-10.0.2.0/24-${data.aws_availability_zones.AZs.names[0]}"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.terraform-task-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.AZs.names[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${terraform.workspace}-10.0.3.0/24-${data.aws_availability_zones.AZs.names[1]}"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.terraform-task-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.AZs.names[1]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${terraform.workspace}-10.0.4.0/24-${data.aws_availability_zones.AZs.names[1]}"
  }
}

# create route tables
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.terraform-task-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    "Name" = "${terraform.workspace}-Public route table"
  }
}
resource "aws_route_table" "private-route-table-1a" {
  vpc_id = aws_vpc.terraform-task-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1a.id
  }

  tags = {
    "Name" = "${terraform.workspace}-Private route table 1a"
  }
}
resource "aws_route_table" "private-route-table-1b" {
  vpc_id = aws_vpc.terraform-task-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1b.id
  }

  tags = {
    "Name" = "${terraform.workspace}-Private route table 1b"
  }
}

# associate public subnets to the public route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}
# associate private subnets to the private route table
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route-table-1a.id
}
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-route-table-1b.id
}

