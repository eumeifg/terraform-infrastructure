include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v2.9.0"
}

inputs = {
  bucket = "tamata-cloudfront-logging"
  acl    = null

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }

  grant = [{
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "5440e66d8eea2deae4425b7cb59d60ed7d024a4d830a31bae33a2788ef2ef917"
    }, {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
  }]

  force_destroy = true

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
          "arn:aws:s3:::tamata-cloudfront-logging/*",
          "arn:aws:s3:::tamata-cloudfront-logging"
        ]
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::986679183949:root"
          ]
        }
      }
    ]
  })
}
