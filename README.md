# AWS Secrets Terraform module

Terraform module which creates secrets in AWS SecretsManager with sensitive, rotatable, random passwords.

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

## Example Command
```bash
AWS_REGION=us-east-1 terragrunt apply -var-file tfvars/secrets.tfvars
```

## Secret Format
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

## Testing
### List secrets, one name per line.
```bash
aws secretsmanager list-secrets --query 'SecretList[*].[Name]' --output text
```

### List secrets and values line by line.
```bash
aws secretsmanager list-secrets --query 'SecretList[*].[Name, ARN]' --output text \
        |xargs -L1 -P1 bash -c 'echo $0 && aws secretsmanager get-secret-value --secret-id $1 --query "SecretString"'
```

## TODO
  * For additional security and ease of use/deployment, retrieve the secret input from S3.
  * Implement a scheduled password rotation methods.
