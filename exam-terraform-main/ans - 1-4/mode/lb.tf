resource "aws_lb" "alb_dolev" {
  name               = "alb-dolev" # שם תקין ל-AWS (עם מקף)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = aws_subnet.Public-Subnet[*].id
}