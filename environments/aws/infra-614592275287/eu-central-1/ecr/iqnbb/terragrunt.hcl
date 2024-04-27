include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/ecr///"
}

inputs = {
  name                 = "iqnbb"
  scan_on_push         = true
  image_tag_mutability = "IMMUTABLE"
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "AllowPushPull",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::094354153681:root",
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
