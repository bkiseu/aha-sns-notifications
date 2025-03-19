# account-specific-repo/variables.tf

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "notification_emails" {
  description = "Email address for notifications"
  type        = list(string)
  default     = []
}
