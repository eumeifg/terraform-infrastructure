include {
  path = find_in_parent_folders()
}

locals {
  base_ecr_vars = read_terragrunt_config(find_in_parent_folders("common/ecr/ecr.hcl"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/ecr///"
}

inputs = merge(
  local.base_ecr_vars.inputs,
  {
    name                 = "ta3leem-cdp-auto-proctoring-collector"
    image_tag_mutability = "IMMUTABLE"
    policy = jsonencode({
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "ecr_drone_user",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::310830963532:user/aj_ecr_drone_user"
            ]
          },
          "Action" : [
            "ecr:InitiateLayerUpload",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:ListTagsForResource",
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:DescribeImages",
            "ecr:DescribeImageScanFindings",
            "ecr:DescribeRegistry",
            "ecr:GetAuthorizationToken",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetLifecyclePolicy",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:GetRegistryPolicy",
            "ecr:GetRepositoryPolicy",
            "ecr:UntagResource",
            "ecr:TagResource",
            "ecr:UploadLayerPart",
            "ecr:StartImageScan",
            "ecr:PutImage",
            "ecr:CompleteLayerUpload"
          ]
        },
        {
          "Sid" : "AllowPushPull",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::419068741072:root",
              "arn:aws:iam::310830963532:root",
              "arn:aws:iam::614592275287:root"
            ]
          },
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:CompleteLayerUpload",
            "ecr:GetDownloadUrlForLayer",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
          ]
        }
      ]
    })
  }
)
