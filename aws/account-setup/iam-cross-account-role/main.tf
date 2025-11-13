# IAM Role for Cross-Account Access with ExternalID
resource "aws_iam_role" "cross_account_role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = var.tags
}

# Assume Role Policy Document
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.trusted_role_arn]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
  }
}

# IAM Policy for Group and User Operations
resource "aws_iam_policy" "iam_readonly_policy" {
  name        = var.policy_name
  description = "Policy allowing read-only IAM operations for groups and users"
  policy      = data.aws_iam_policy_document.iam_readonly_policy.json

  tags = var.tags
}

# IAM Policy Document for Group and User Operations
data "aws_iam_policy_document" "iam_readonly_policy" {
  statement {
    effect = "Allow"

    actions = [
      "iam:GetGroup",
      "iam:ListGroups",
      "iam:GetUser",
      "iam:ListGroupsForUser"
    ]

    resources = ["*"]
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.iam_readonly_policy.arn
}
