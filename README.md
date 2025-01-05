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
# NOTE to be executed from the example directory
# NOTE the terraform s3 backend "region" attribute or the AWS_REGION or AWS_DEFAULT_REGION environment variables must be set

terragrunt apply -var-file tfvars/secrets.tfvars
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
  * Always use private, remote backend for terraform state to ensure that sensitive data is never stored locally.
  * If a randomly generated password is desired for the secret, simply ensure that the password attribute is present in the secret specification.
  * For security reasons, the input password values are ignored. Only randomly generated passwords created at runtime are supported.
  * The optional rotation attribute controls password regeneration. Simply increment to update a password prior to applying the config.
  * To protect from exposing sensitive information, the var file need not be stored in a repo. Simply pass the location of the file via command line flag.

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
  * Implement a scheduled password rotation strategy.
  * Write and configure a Lambda function that creates and rotates secrets, thereby removing passwords from the state file.
