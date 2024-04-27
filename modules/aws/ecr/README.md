## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_ecr_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) |
| [aws_ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) |
| [aws_ecr_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) |
| [aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| encryption\_type | The encryption type to use for the repository. Valid values are `AES256` or `KMS` | `string` | `"AES256"` | no |
| image\_scanning\_configuration | Configuration block that defines image scanning configuration for the repository. By default, image scanning must be manually triggered. | `map(string)` | `{}` | no |
| image\_tag\_mutability | The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. | `string` | `"MUTABLE"` | no |
| kms\_key | The ARN of the KMS key to use when encryption\_type is `KMS`. If not specified when encryption\_type is `KMS`, uses a new KMS key. Otherwise, uses the default AWS managed key for ECR. | `string` | `null` | no |
| lifecycle\_policy | Manages the ECR repository lifecycle policy | `string` | `null` | no |
| name | Name of the repository. | `string` | n/a | yes |
| policy | Manages the ECR repository policy | `string` | `null` | no |
| scan\_on\_push | Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false). | `bool` | `true` | no |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| timeouts | Timeouts map. | `map(string)` | `{}` | no |
| timeouts\_delete | How long to wait for a repository to be deleted. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Full ARN of the repository |
| name | The name of the repository. |
| registry\_id | The registry ID where the repository was created. |
| repository\_url | The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`) |
