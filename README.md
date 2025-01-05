# AWS Secrets Terraform module

Terraform module which creates rotatable, sensitive secrets on AWS.

## Usage
```hcl
// always use private, remote backend for state
terraform {
  backend "s3" {}
}

module "terraform-aws-secrets" {
	source = "github.com/mbalkanloo/terraform-aws-secrets"
	secrets = var.secrets
	password_length = 32
}
```

## Command
```bash
USAGE AWS_REGION=us-east-1 terragrunt apply -var-file tfvars/secrets.tfvars
```

## Format
```hcl
secrets = [
	{
		name = "testing/secret1"
		rotation = 0
		secret = {
			name = "foo"
			password = null
		}
	},
	{
		name = "testing/secret2"
		secret = {
			key = "bar"
		}
	}
]
```

## Security
	* If a randomly generated password is desired for the secret, simply ensure that the password attribute is present in the secret specification.
	* For security reasons, the var file password attribute is ignored. Only randomly generated passwords created at runtime are supported.
	* The rotation attribute controls password regeneration. Simply increment to update the password. 
	* The var file can be stored locally to avoid exposing sensitive secret information.

## TODO
	* For additional security and ease of use/deployment, retrieve the secret input from S3.
	* Implement a scheduled password rotation methods.
