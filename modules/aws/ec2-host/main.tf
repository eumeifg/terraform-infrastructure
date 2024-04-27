resource "aws_ec2_host" "main" {
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  auto_placement    = var.auto_placement

  tags = {
    Name = var.name
  }
}
