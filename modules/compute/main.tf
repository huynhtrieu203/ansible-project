// Create EC2
resource "aws_instance" "instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  count           = 2
  subnet_id       = data.aws_subnet.public_subnet[count.index].id
  security_groups = [data.aws_security_group.instances_sg.id]
  key_name = "ansible_key"
  tags = {
    "Name" = "instance-${count.index}}"
  }
}

// Create target group
resource "aws_lb_target_group" "tg" {
  name        = "TargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id
}

// Attach target group
resource "aws_alb_target_group_attachment" "tg-attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  port = 80
  target_id        = aws_instance.instance[count.index].id
  count            = length(aws_instance.instance)
}

// Create load balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.alb_sg.id]
  subnets            = [for subnet in data.aws_subnet.public_subnet : subnet.id]
}

// Create listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

// Create listener rule
resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}