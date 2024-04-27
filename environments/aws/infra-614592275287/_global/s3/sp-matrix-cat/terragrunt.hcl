include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v2.14.1"
}

inputs = {
  bucket = "sp-matrix-cat"
  acl    = "private"

  attach_policy = true

  policy = <<POLICY
        {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Sid": "PublicReadGetObject",
                  "Effect": "Allow",
                  "Principal": "*",
                  "Action": "s3:GetObject",
                  "Resource": "arn:aws:s3:::sp-matrix-cat/*"
              }
          ]
        }
        POLICY

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  versioning = {
    enabled = false
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = local.tags
}
