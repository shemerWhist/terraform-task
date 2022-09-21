
# launch configuration
resource "aws_launch_configuration" "launch-configuration" {
  name_prefix            = "terraform-task-config-"
  image_id      = var.ami
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-instance_profile.name
  security_groups = [ var.public-sg-id ]
  key_name = "key-for-task"
  user_data = file("/mnt/c/Users/sheme/Desktop/Terraform practice/modules/asg/user_data.sh")

 lifecycle {
    create_before_destroy = true
  }
}

# create an auto scaling group
resource "aws_autoscaling_group" "asg-main" {
  name = "asg-terraform-task"
  vpc_zone_identifier = [ var.public_subnet1_id, var.public_subnet2_id ]
  launch_configuration = aws_launch_configuration.launch-configuration.name
  
  min_size = 2
  max_size = 4
  desired_capacity = 2
  health_check_grace_period = 100

  lifecycle {
    create_before_destroy = true
  }
}

# create auto scaling policy
resource "aws_autoscaling_policy" "scale-up" {
  name = "asg-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown = 100
  autoscaling_group_name = aws_autoscaling_group.asg-main.name
}

resource "aws_autoscaling_policy" "scale-down" {
  name = "asg-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown = 100
  autoscaling_group_name = aws_autoscaling_group.asg-main.name
}

# create cloudWatch alarms
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-up" {
    alarm_name = "cpu-alaram-up"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    evaluation_periods = "2"
    period = "120"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    statistic = "Average"
    threshold = "60"
    alarm_actions = [ aws_autoscaling_policy.scale-up.arn ]

    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.asg-main.name
    }

    alarm_description = "This metric monitors ec2 cpu utilization above 60%"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-down" {
    alarm_name = "cpu-alaram-down"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    evaluation_periods = "2"
    period = "120"
    comparison_operator = "LessThanOrEqualToThreshold"
    statistic = "Average"
    threshold = "40"
    alarm_actions = [ aws_autoscaling_policy.scale-down.arn ]

    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.asg-main.name
    }

    alarm_description = "This metric monitors ec2 cpu utilization less then 40%"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsEc2ExecutionRole" {
  name               = "terraform-task-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecsEc2ExecutionRole_policy" {
  role       = aws_iam_role.ecsEc2ExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2-instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ecsEc2ExecutionRole.name
}
