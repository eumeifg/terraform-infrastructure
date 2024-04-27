data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_lb" "alb" {
  name = var.alb_name
}

data "aws_lb" "nlb" {
  arn = aws_lb.this.arn
}
