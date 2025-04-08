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
# You'll need to get this from your Datadog AWS integration page. Contact CloudOps for details
# https://docs.datadoghq.com/integrations/guide/aws-manual-setup/?tab=roledelegation#generate-an-external-id
variable "datadog_external_id" {
  description = "External ID provided by Datadog"
  type        = string
  
}

# https://docs.datadoghq.com/integrations/guide/aws-manual-setup/?tab=roledelegation#aws-iam-role-for-datadog
variable "datadog_aws_account_id" {
  description = "Datadog's AWS account ID"
  type        = string
  default     = "464622532012" # This is Datadog's standard AWS account ID
}

variable "role_name" {
  description = "Name of the IAM role for Datadog"
  type        = string
  default     = "DatadogAWSIntegrationRole"
}