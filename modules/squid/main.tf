resource "aws_instance" "squid" {
  ami                  = "ami-0ec7f9846da6b0f61"
  instance_type        = var.instance_type
  iam_instance_profile = module.instance_profile.instance_profile_name
  key_name             = var.aws_key_name
  user_data            = file("${path.module}/provision.sh")

  vpc_security_group_ids = [
    aws_security_group.squid.id
  ]

  subnet_id = var.public_subnet_id

  tags = merge(
    tomap({"Name" = format("%s-%s", var.resource_name_prefix, "squid")}),
    var.tags,
  )

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

}

resource "aws_eip" "squid" {
  instance = aws_instance.squid.id
  vpc      = true
}

module "instance_profile" {
  source      = "./instance-profile/"
  role_name   = "${var.resource_name_prefix}-role"
  policy_arns = ["arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"]

  create_instance_role = true
  policy_arns_count    = 4
}

