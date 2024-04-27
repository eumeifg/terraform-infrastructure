include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v2.9.0"
}

inputs = {
  bucket = "tamata-static-assets-prod"
  acl    = "private"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  tags = local.tags

  attach_policy = true

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::tamata-static-assets-prod/*",
          "arn:aws:s3:::tamata-static-assets-prod"
        ]
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::986679183949:root"
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E1E40W55SWX621"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::tamata-static-assets-prod/*"
      }
    ]
  })
}
