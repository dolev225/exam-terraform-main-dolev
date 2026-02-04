resource "aws_lb_target_group" "tg" {
  name     = "dolev-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_dolev.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}