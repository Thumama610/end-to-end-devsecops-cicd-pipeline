resource "aws_instance" "nexus-server" {
  ami                    = "ami-0b6c6ebed2801a5cb"      
  instance_type          = "t3.xlarge"
  key_name               = "private-key"             
  vpc_security_group_ids = [aws_security_group.nexus-server-sg.id]
  user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "nexus-server"
  }

  root_block_device {
    volume_size = 8
  }
}

resource "aws_security_group" "nexus-server-sg" {
  name        = "nexus-server-sg"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8081] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nexus-server-sg"
  }
}