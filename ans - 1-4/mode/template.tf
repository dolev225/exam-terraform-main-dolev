# שנה את הסוג מ-aws_instance ל-aws_launch_template
resource "aws_launch_template" "my_template" {
  name_prefix   = "my-server-lt"
  image_id      = "ami-0c398cb65a93047f2"
  instance_type = var.instance_type
  key_name      = "dolev1234"

  # ב-Launch Template משתמשים ב-vpc_security_group_ids
  network_interfaces {
    associate_public_ip_address = var.if_Public_ip
    security_groups             = [aws_security_group.sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              echo "<h1>Hello from ASG</h1>" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "template_dolev"
    }
  }
}