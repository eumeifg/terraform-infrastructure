include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/ecr///"
}

inputs = {
  name                 = "cs_deployment-service"
  scan_on_push         = true
  image_tag_mutability = "IMMUTABLE"
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "EXTERNAL_EL",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::024658484249:user/external_el"
          ]
        },
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings"
        ]
      },
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
            "arn:aws:iam::024658484249:root",
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
