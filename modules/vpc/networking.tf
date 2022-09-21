
# create internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.terraform-task-vpc.id

  tags = {
    "Name" = "${terraform.workspace}-Internet Gateway"
  }
}

# create NACL
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.terraform-task-vpc.id

  tags = {
    "Name" = "${terraform.workspace}-NACL"
  }
}

# NACL rules
# inbound
resource "aws_network_acl_rule" "in-ssh" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# outbound
resource "aws_network_acl_rule" "out-http" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# associate NACL
resource "aws_network_acl_association" "nacl-subnet1-association" {
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_network_acl_association" "nacl-subnet2-association" {
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

# create EIP 
resource "aws_eip" "eip-1a" {
  vpc = true
  depends_on = [
    aws_internet_gateway.IGW
  ]

  tags = {
    "Name" = "${terraform.workspace}-EIP 1a"
  }
}
resource "aws_eip" "eip-1b" {
  vpc = true
  depends_on = [
    aws_internet_gateway.IGW
  ]

  tags = {
    "Name" = "${terraform.workspace}-EIP 1b"
  }
}

# create NAT gateways
resource "aws_nat_gateway" "nat-1a" {
  allocation_id = aws_eip.eip-1a.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    "Name" = "${terraform.workspace}-NAT gateway 1a"
  }
}
resource "aws_nat_gateway" "nat-1b" {
  allocation_id = aws_eip.eip-1b.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    "Name" = "${terraform.workspace}-NAT gateway 1b"
  }
}