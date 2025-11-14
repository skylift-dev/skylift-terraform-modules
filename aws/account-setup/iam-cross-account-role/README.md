<!-- BEGIN_TF_DOCS -->
# `skylift.dev` AWS Account Setup Module

This Terraform module creates an AWS IAM role that can be assumed by the `skylift.dev` AWS Account Reader role which synchronizes AWS IAM groups and IAM user memberships

## Features

- Creates an IAM role that can be assumed by the `skylift.dev` service account role.
- `skylift.dev` will pass the unique Account ID as the ExternalID when assuming the role for added security
- Grants permissions for IAM operations:
  - List and get IAM groups
  - Get IAM users
  - List groups for users
  - Add a user to a group
  - Remove a user from a group

## Usage

```hcl
module "skylift_account_role" {
  source = "./aws/account-setup/iam-cross-account-role"

  role_name        = "SkyliftServiceAccount"
  policy_name      = "SkyliftPermissions"
  # The actual `skylift.dev` AWS IAM Role ARN is available in the docs
  trusted_role_arn = "arn:aws:iam::123456789012:role/TrustedRole"
  external_id      = "<your Skylift AWS Account ID>"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## License

This module is provided as-is for use with skylift.dev infrastructure.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iam_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the IAM policy to create | `string` | n/a | yes |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | Path of the IAM policy to create | `string` | `"/"` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the IAM role | `string` | `"Cross-account IAM role with access to IAM groups and users"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role to create | `string` | n/a | yes |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of the IAM role to create | `string` | `"/"` | no |
| <a name="input_skylift_account_external_id"></a> [skylift\_account\_external\_id](#input\_skylift\_account\_external\_id) | External ID for assuming the role (used to prevent confused deputy problem) | `string` | n/a | yes |
| <a name="input_skylift_account_reader_iam_role_arn"></a> [skylift\_account\_reader\_iam\_role\_arn](#input\_skylift\_account\_reader\_iam\_role\_arn) | ARN of the IAM role in the trusted account that can assume this role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the IAM role and policy | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | ARN of the created IAM policy |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | Name of the created IAM policy |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the created IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the created IAM role |
<!-- END_TF_DOCS -->

