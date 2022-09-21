# create security groups
# public security group
resource "aws_security_group" "public-group" {
  name        = "${terraform.workspace}-public-group"
  description = "public security group"
  vpc_id      = var.vpc_id
}

# rules 
resource "aws_security_group_rule" "public-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-group.id
}
resource "aws_security_group_rule" "public-in-ssh" {
  type              = "ingress"
  description       = "ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-group.id
}
resource "aws_security_group_rule" "public-in-http" {
  type              = "ingress"
  description       = "http"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-group.id
}

# private security group
resource "aws_security_group" "private-group" {
  name        = "${terraform.workspace}-private-group"
  description = "public security group"
  vpc_id      = var.vpc_id
}

# rules
resource "aws_security_group_rule" "private-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private-group.id
}
resource "aws_security_group_rule" "private-in-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.vpc-cidr-block]
  security_group_id = aws_security_group.private-group.id
}
resource "aws_security_group_rule" "private-in-http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [var.vpc-cidr-block]

  security_group_id = aws_security_group.private-group.id
}

# application load balancer security group
resource "aws_security_group" "alb-group" {
  name        = "${terraform.workspace}-alb-group"
  description = "application load balancer security group"
  vpc_id      = var.vpc_id
}

# rules
resource "aws_security_group_rule" "alb-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-group.id
}
resource "aws_security_group_rule" "alb-in-http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.alb-group.id
}
resource "aws_security_group_rule" "alb-in-https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.alb-group.id
}
