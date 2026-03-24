resource "aws_instance" "worker2-server" {
  ami                    = "ami-0b6c6ebed2801a5cb"      
  instance_type          = "t3.large"
  key_name               = "private-key"             
  vpc_security_group_ids = [aws_security_group.k8s-servers-sg.id]
  user_data              = templatefile("./install-k8s-worker.sh", {})
  subnet_id              = data.aws_subnet.default_az.id
  associate_public_ip_address = true

  tags = {
    Name = "worker2-server"
  }

  root_block_device {
    volume_size = 20
  }
}
