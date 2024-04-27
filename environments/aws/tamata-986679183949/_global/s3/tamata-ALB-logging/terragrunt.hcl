include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v2.11.1"
}

inputs = {
  bucket = "tamata-alb-logging"
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
          "arn:aws:s3:::tamata-alb-logging/*",
          "arn:aws:s3:::tamata-alb-logging"
        ]
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::986679183949:root",
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::054676820928:root"
        },
        "Action" : "s3:PutObject",
        "Resource" : [
          "arn:aws:s3:::tamata-alb-logging/ingress-staging/AWSLogs/986679183949/*",
          "arn:aws:s3:::tamata-alb-logging/ingress-prod/AWSLogs/986679183949/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : [
          "arn:aws:s3:::tamata-alb-logging/ingress-staging/AWSLogs/986679183949/*",
          "arn:aws:s3:::tamata-alb-logging/ingress-prod/AWSLogs/986679183949/*"
        ]
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "arn:aws:s3:::tamata-alb-logging"
      }
    ]
  })
}
