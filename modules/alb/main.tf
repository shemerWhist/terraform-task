
# create application load balancer
resource "aws_lb" "alb" {
  name               = "${terraform.workspace}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnet1_id, var.public_subnet2_id]
  security_groups    = [var.alb-sg-id]

  tags = {
    "Name" = "${terraform.workspace}-alb"
  }
}

# create a target group
resource "aws_lb_target_group" "target-group" {
  name     = "${terraform.workspace}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # health_check {
  #   interval = 10
  #   path = "/"
  #   protocol = "HTTP"
  #   timeout = 5
  #   healthy_threshold = 5
  #   unhealthy_threshold = 2

  # }
}

# load balancer listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

# attach private instances to target group
resource "aws_lb_target_group_attachment" "attach-private-instance-1a" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = var.public-instance-1a-id
  # target_id = var.private-instance-1a-id
}
resource "aws_lb_target_group_attachment" "attach-private-instance-1b" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = var.public-instance-1b-id
  # target_id = var.private-instance-1b-id
}