// USAGE AWS_REGION=us-east-1 terragrunt apply -var-file tfvars/secrets.tfvars

// always use private, remote backend for state
terraform {
  backend "s3" {}
}

module "terraform-aws-secrets" {
	source = "github.com/mbalkanloo/terraform-aws-secrets"
	secrets = var.secrets
	password_length = 32
}
