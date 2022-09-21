output "alb-dns-name" {
  value = module.alb.alb-dns-name
}

output "alb-arn" {
  value = module.alb.alb-arn
}

output "user-data" {
    value = module.asg.user-data
  
}