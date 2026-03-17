data "aws_subnet" "default_az" {
  availability_zone = "us-east-1a"

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}