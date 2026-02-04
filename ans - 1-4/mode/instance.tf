resource "aws_instance" "my_server" {
  count =var.Subnet_count
  ami                    = "ami-0c398cb65a93047f2" 
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Public-Subnet[count.index].id
  associate_public_ip_address = var.if_Public_ip
  vpc_security_group_ids = [aws_security_group.sg.id]
  #key_name               = "dolev1234"

  tags = {
    Name = "vm_dolev"
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF
  )
  }

}
