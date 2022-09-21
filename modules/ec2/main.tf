
# find and filter the right ami in the region
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20220831-x86_64-ebs"]
  }
}

# private instances
resource "aws_instance" "private-1a" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = "key-for-task"

  network_interface {
    network_interface_id = aws_network_interface.private-1a.id
    device_index         = 0
  }

  tags = {
    "Name" = "${terraform.workspace}-private-instance-1a"
  }
}
resource "aws_instance" "private-1b" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = "key-for-task"

  network_interface {
    network_interface_id = aws_network_interface.private-1b.id
    device_index         = 0
  }

  tags = {
    "Name" = "${terraform.workspace}-private-instance-1b"
  }
}

# public instances
resource "aws_instance" "public-1a" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = "key-for-task"

  network_interface {
    network_interface_id = aws_network_interface.public-1a.id
    device_index         = 0
  }

  tags = {
    "Name" = "${terraform.workspace}-public-instance-1a"
  }
}
resource "aws_instance" "public-1b" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = "key-for-task"

  network_interface {
    network_interface_id = aws_network_interface.public-1b.id
    device_index         = 0
  }

  tags = {
    "Name" = "${terraform.workspace}-public-instance-1b"
  }
}

