resource "aws_instance" "mac" {
  ami                    = var.custom_ami
  instance_type          = "mac1.metal"
  key_name               = var.key_name
  availability_zone      = var.availability_zone
  host_id                = var.dedicated_host_id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device {
    volume_size = 512
    volume_type = "gp3"
  }

  tags = {
    Name = var.name
  }
}
