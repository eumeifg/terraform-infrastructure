resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_role_policy.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  count      = var.policy_arns_count
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_role ? 1: 0
  name  = aws_iam_role.this.name
  role  = aws_iam_role.this.name
}

data "aws_iam_policy_document" "ec2_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    effect = "Allow"
  }
}
