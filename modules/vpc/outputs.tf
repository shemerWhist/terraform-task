
output "vpc-id" {
  value = aws_vpc.terraform-task-vpc.id
}

output "vpc-cidr-block" {
  value = aws_vpc.terraform-task-vpc.cidr_block
}

output "private-subnet1" {
  value = aws_subnet.private-subnet-1
}

output "private-subnet2" {
  value = aws_subnet.private-subnet-2
}

output "public-subnet1" {
  value = aws_subnet.public-subnet-1
}

output "public-subnet2" {
  value = aws_subnet.public-subnet-2
}