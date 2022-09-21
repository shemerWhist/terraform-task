output "asg-arn" {
    value = aws_autoscaling_group.asg-main.arn
}

output "user-data" {
    value = aws_launch_configuration.launch-configuration.user_data
  
}
