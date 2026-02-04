resource "aws_autoscaling_group" "my_asg" {
  vpc_zone_identifier = aws_subnet.Public-Subnet[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}