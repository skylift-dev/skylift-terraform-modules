output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.cross_account_role.arn
}

output "role_name" {
  description = "Name of the created IAM role"
  value       = aws_iam_role.cross_account_role.name
}

output "role_id" {
  description = "ID of the created IAM role"
  value       = aws_iam_role.cross_account_role.id
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.iam_readonly_policy.arn
}

output "policy_name" {
  description = "Name of the created IAM policy"
  value       = aws_iam_policy.iam_readonly_policy.name
}
