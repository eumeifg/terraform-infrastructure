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
  bucket = "tasleem-backups"
  acl    = "private"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = "arn:aws:kms:eu-central-1:693108475297:alias/aws/s3"
        sse_algorithm     = "aws:kms"
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
          "arn:aws:s3:::tasleem-backups/*",
          "arn:aws:s3:::tasleem-backups"
        ]
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::693108475297:user/frappe-backup"
          ]
        }
      }
    ]
  })
}
