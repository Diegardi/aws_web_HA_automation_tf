resource "aws_lb_target_group" "target_group" {
  name     = "DGTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.training_vpc.id
}

resource "aws_alb_target_group_attachment" "target_group_attachment" {
  count            = length(aws_instance.instance.*.id) == 2 ? 2 : 0
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = element(aws_instance.instance.*.id, count.index)
}

resource "aws_lb" "load_balancer" {
  name               = "DG-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instances_security_group.id, ]
  subnets            = aws_subnet.public_subnet.*.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn

  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}