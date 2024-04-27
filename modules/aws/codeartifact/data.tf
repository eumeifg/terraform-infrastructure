data "aws_iam_policy_document" "this" {
  statement {
      actions = [
        "codeartifact:CreateRepository",
        "codeartifact:DescribePackageVersion",
        "codeartifact:DescribeRepository",
        "codeartifact:GetPackageVersionReadme",
        "codeartifact:GetRepositoryEndpoint",
        "codeartifact:ListPackageVersionAssets",
        "codeartifact:ListPackageVersionDependencies",
        "codeartifact:ListPackageVersions",
        "codeartifact:ListPackages",
        "codeartifact:PublishPackageVersion",
        "codeartifact:PutPackageMetadata",
        "codeartifact:ReadFromRepository"
      ]

      effect = "Allow"

      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = var.principals
      }
  }

  statement {
    actions = [
      "codeartifact:CreateRepository",
      "codeartifact:DescribeDomain",
      "codeartifact:GetAuthorizationToken",
      "codeartifact:GetDomainPermissionsPolicy",
      "codeartifact:ListRepositoriesInDomain",
      "sts:GetServiceBearerToken"
    ]

    effect = "Allow"

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = var.principals
    }
  }

}
