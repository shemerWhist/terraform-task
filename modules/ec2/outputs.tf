output "private-instance-1a-id" {
  value       = aws_instance.private-1a.id
  description = "private instance 1a id"
}
output "private-instance-1b-id" {
  value       = aws_instance.private-1b.id
  description = "private instance 1b id"
}

output "public-instance-1a-id" {
  value       = aws_instance.public-1a.id
  description = "public instance 1a id"
}
output "public-instance-1b-id" {
  value       = aws_instance.public-1b.id
  description = "public instance 1b id"
}

output "ami-for-instance" {
  value = data.aws_ami.amazon-linux-2
  description = "ami for instances"
}