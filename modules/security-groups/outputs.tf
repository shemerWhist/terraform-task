output "public-group-id" {
  value       = aws_security_group.public-group.id
  description = "public sg id"
}

output "private-group-id" {
  value       = aws_security_group.private-group.id
  description = "private sg id"
}

output "alb-security-group-id" {
  value       = aws_security_group.alb-group.id
  description = "application load balancer sg id"
}