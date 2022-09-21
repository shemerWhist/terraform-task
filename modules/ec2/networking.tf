
# create network interfaces

# private interfaces
resource "aws_network_interface" "private-1a" {
  subnet_id       = var.private_subnet1_id
  security_groups = ["${var.private-sg-id}"]

  tags = {
    "Name" = "${terraform.workspace}-private-1a-network-interface"
  }
}
resource "aws_network_interface" "private-1b" {
  subnet_id       = var.private_subnet2_id
  security_groups = ["${var.private-sg-id}"]

  tags = {
    "Name" = "${terraform.workspace}-private-1b-network-interface"
  }
}

# public interfaces
resource "aws_network_interface" "public-1a" {
  subnet_id       = var.public_subnet1_id
  security_groups = ["${var.public-sg-id}"]

  tags = {
    "Name" = "${terraform.workspace}-public-1a-network-interface"
  }
}
resource "aws_network_interface" "public-1b" {
  subnet_id       = var.public_subnet2_id
  security_groups = ["${var.public-sg-id}"]

  tags = {
    "Name" = "${terraform.workspace}-public-1b-network-interface"
  }
}