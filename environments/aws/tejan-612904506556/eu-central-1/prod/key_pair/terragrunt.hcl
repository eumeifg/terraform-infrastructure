include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("prod.hcl"))
  environment = local.common_vars.locals.environment_name
  tags        = local.common_vars.locals.common_tags
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git///?ref=v1.0.1"
}

inputs = {
  key_name   = "windows-host"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCGpb2NLxf+1CjYNkH7y80x+7Dd/GPGDTyw6IkhVz1gUbqP9FqQrJXLiXNPMayceBplUs/YxlWfs51gnCCuabwcRlk4EajKm8whXicExzx/nihrl1atBUYKaM3A2FNpuJ4IyYJt8PPWDQ2QVxu6xPRRaj+JEEiTjnmLuf7IS69p9pfPc+04gRRInQ7bFo4+5pffzd7Zb/EFhmiwclq3gDb8TvtFErSTGbyqgjMXRMYIWx1+RMD5Aecxpg2HMN8708Bva7UDFBJQzJ/v6qSThEsl1Kzy+tNSt3QuiriIVAYhcKPae/C4xX6NHY2XveaPrQGrQrnfXP6oQ4thVzKkSgtAyKiFW2M9cyjv4XOKofQNM/LG7H6EX0M1kyY01dUGLcsHB9oPv1Q5z0tAcjAihRiTBbBO8SgyQt4JqPADe8gV23vqFu0ANUoEsPbnbMjo+5bY/8FC2xJlIgF4ks2FhQNBM2A32NODJr5PDKw8wVIku7N0ocZp9MgDFq2z8PZJxw76JiPeGxIWm+96pkaXIbUxvL/Fjq/Rmuuwrh6I5DBc7MSnBKEnpgnW4dgr2ULqQxkB4T/JaRzDYjRousZG4k6c0WWME4x2HrrtnYoZydnMKF4blt1MCMCQotvbS5ZWIECNxN3eVzIFnsXJQujXQrb/EAV0OWHhBtLbXQ4KCYNLqQ== tajen-key"

  tags = local.tags
}
