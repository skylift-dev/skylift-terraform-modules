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
  description = "Policy allowing read-only IAM operations for groups and users"
  policy      = data.aws_iam_policy_document.iam_readonly.json

  tags = var.tags
}

# IAM Policy Document for Group and User Operations
data "aws_iam_policy_document" "iam_readonly" {
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
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
