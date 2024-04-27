# README

## Setup tools

Run the following commands within the root directory of the project to install the required setup tools:

    brew bundle

**Note**: If you get the error - `Cannot install under Rosetta 2 in ARM default prefix (/opt/homebrew)`, rerun under ARM using - `arch -arm64 brew bundle`

    tgenv install
    tfenv install

## Prerequites

Before running the Terragrunt plan applying your changes using Terragrunt apply, endeavour to do the following:

* Login to the aws account using the:

    aws sso login --profile <the-desired-aws-profile>

* For Kubernetes, switch to the kube context of the Kubernetes cluster that you want to apply the changes to using the command:

    aws eks --region eu-central-1 --profile <the-desired-aws-profile> update-kubeconfig --name eks-taza-prod --role-arn <the-desired-aws-role-arn> --alias <the-desired-aws-profile>

* Finally, change your terminal directory to the directory where you want to run the Terragrunt changes using:

    cd <the-terragrunt-directory>

## Terragrunt

To apply your desired changes, run the below commands:

### Individual resources

Replace `root-DevOps` with your creative infra AWS root profile.

**Init**:

    AWS_PROFILE=root-DevOps terragrunt init

**Plan**:

    AWS_PROFILE=root-DevOps terragrunt plan

**Apply**:

    AWS_PROFILE=root-DevOps terragrunt apply

### All resources

Replace `root-DevOps` with your creative infra AWS root profile.

**Init**:

    AWS_PROFILE=root-DevOps terragrunt run-all init

**Plan**:

    AWS_PROFILE=root-DevOps terragrunt run-all plan

**Apply**:

    AWS_PROFILE=root-DevOps terragrunt run-all apply
