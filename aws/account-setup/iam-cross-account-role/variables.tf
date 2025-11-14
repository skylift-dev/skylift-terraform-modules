variable "role_path" {
  description = "Path of the IAM role to create"
  type        = string
  default     = "/"
}

variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Cross-account IAM role with access to IAM groups and users"
}

variable "policy_path" {
  description = "Path of the IAM policy to create"
  type        = string
  default     = "/"
}

variable "policy_name" {
  description = "Name of the IAM policy to create"
  type        = string
}

variable "skylift_account_reader_iam_role_arn" {
  description = "ARN of the IAM role in the trusted account that can assume this role"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.skylift_account_reader_iam_role_arn))
    error_message = "The trusted_role_arn must be a valid IAM role ARN (e.g., arn:aws:iam::123456789012:role/RoleName)"
  }
}

variable "skylift_account_external_id" {
  description = "External ID for assuming the role (used to prevent confused deputy problem)"
  type        = string

  validation {
    condition     = length(var.skylift_account_external_id) >= 2 && length(var.skylift_account_external_id) <= 1224
    error_message = "The external_id must be between 2 and 1224 characters"
  }
}

variable "tags" {
  description = "Tags to apply to the IAM role and policy"
  type        = map(string)
  default     = {}
}
