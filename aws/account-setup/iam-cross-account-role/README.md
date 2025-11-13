# IAM Cross-Account Role Module

This Terraform module creates an AWS IAM role that can be assumed from another AWS account using cross-account access with an ExternalID for enhanced security. The role is granted read-only permissions for IAM groups and users operations.

## Features

- Creates an IAM role with cross-account assume role capability
- Implements ExternalID validation to prevent confused deputy attacks
- Grants read-only permissions for IAM operations:
  - List and get IAM groups
  - Get IAM users
  - List groups for users
- Configurable role and policy names
- Support for custom tags

## Usage

```hcl
module "cross_account_iam_role" {
  source = "./aws/account-setup/iam-cross-account-role"

  role_name        = "CrossAccountIAMReadRole"
  policy_name      = "CrossAccountIAMReadPolicy"
  trusted_role_arn = "arn:aws:iam::123456789012:role/TrustedRole"
  external_id      = "unique-external-id-string"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Example: Assuming the Role from Another Account

Once the role is created, you can assume it from the trusted account:

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::TARGET_ACCOUNT_ID:role/CrossAccountIAMReadRole \
  --role-session-name my-session \
  --external-id unique-external-id-string
```

Or in Terraform:

```hcl
data "aws_caller_identity" "current" {}

provider "aws" {
  alias = "target_account"

  assume_role {
    role_arn     = module.cross_account_iam_role.role_arn
    external_id  = var.external_id
    session_name = "terraform-session"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| role_name | Name of the IAM role to create | `string` | n/a | yes |
| policy_name | Name of the IAM policy to create | `string` | n/a | yes |
| trusted_role_arn | ARN of the IAM role in the trusted account that can assume this role | `string` | n/a | yes |
| external_id | External ID for assuming the role (used to prevent confused deputy problem) | `string` | n/a | yes |
| role_description | Description of the IAM role | `string` | `"Cross-account IAM role with read-only access to IAM groups and users"` | no |
| tags | Tags to apply to the IAM role and policy | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | ARN of the created IAM role |
| role_name | Name of the created IAM role |
| role_id | ID of the created IAM role |
| policy_arn | ARN of the created IAM policy |
| policy_name | Name of the created IAM policy |

## IAM Permissions Granted

This module grants the following IAM permissions to the role:

- `iam:GetGroup` - Retrieve information about a specific IAM group
- `iam:ListGroups` - List all IAM groups in the account
- `iam:GetUser` - Retrieve information about a specific IAM user
- `iam:ListGroupsForUser` - List all groups that a user belongs to

## Security Considerations

### ExternalID

This module requires an `external_id` parameter which helps prevent the "confused deputy" problem in cross-account access scenarios. The ExternalID must be:
- Between 2 and 1224 characters long
- Unique and secret (treat it like a password)
- Shared only between the accounts that need access

### Trusted Role ARN

The `trusted_role_arn` parameter specifies which IAM role from another account is allowed to assume this role. Make sure to:
- Use the most specific role ARN possible (avoid using account-level principals)
- Validate the ARN format (the module includes validation)
- Regularly review and audit which roles have access

## Best Practices

1. **Generate secure ExternalIDs**: Use a cryptographically secure random string generator
2. **Store ExternalIDs securely**: Use AWS Secrets Manager or similar secret management service
3. **Implement least privilege**: This module grants read-only IAM permissions; avoid adding unnecessary permissions
4. **Use tags**: Apply appropriate tags for cost tracking and resource management
5. **Monitor usage**: Enable CloudTrail logging to monitor assume role operations

## License

This module is provided as-is for use with skylift.dev infrastructure.
