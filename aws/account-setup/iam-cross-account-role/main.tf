/**
* # `skylift.dev` AWS Account Setup Module
* 
* This Terraform module creates an AWS IAM role that can be assumed by the `skylift.dev` AWS Account Reader role which synchronizes AWS IAM groups and IAM user memberships
* 
* ## Features
* 
* - Creates an IAM role that can be assumed by the `skylift.dev` service account role.
* - `skylift.dev` will pass the unique Account ID as the ExternalID when assuming the role for added security
* - Grants permissions for IAM operations:
*   - List and get IAM groups
*   - Get IAM users
*   - List groups for users
*   - Add a user to a group
*   - Remove a user from a group
* 
* ## Usage
* 
* ```hcl
* module "skylift_account_role" {
*   source = "./aws/account-setup/iam-cross-account-role"
* 
*   role_name        = "SkyliftServiceAccount"
*   policy_name      = "SkyliftPermissions"
*   # The actual `skylift.dev` AWS IAM Role ARN is available in the docs
*   trusted_role_arn = "arn:aws:iam::123456789012:role/TrustedRole"
*   external_id      = "<your Skylift AWS Account ID>"
* 
*   tags = {
*     Environment = "production"
*     ManagedBy   = "terraform"
*   }
* }
* ```
* 
* ## License
* 
* This module is provided as-is for use with skylift.dev infrastructure.
* 
*/

resource "aws_iam_role" "this" {
  name               = var.role_name
  path               = var.role_path
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

# Assume Role Policy Document
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.skylift_account_reader_iam_role_arn]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.skylift_account_external_id]
    }
  }
}

# IAM Policy for Group and User Operations
resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = "Policy allowing IAM operations on groups and users"
  policy      = data.aws_iam_policy_document.iam_permissions.json

  tags = var.tags
}

# IAM Policy Document for Group and User Operations
data "aws_iam_policy_document" "iam_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "iam:GetGroup",
      "iam:ListGroups",
      "iam:GetUser",
      "iam:ListGroupsForUser",
      "iam:RemoveUserFromGroup",
      "iam:AddUserToGroup",
    ]

    resources = ["*"]
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
