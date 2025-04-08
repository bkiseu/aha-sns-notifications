# AWS Health Awareness (AHA) Project Documentation

## Overview

The AWS Health Awareness (AHA) project is a monitoring infrastructure designed to capture AWS Health events and route them to appropriate notification channels. It uses AWS EventBridge (CloudWatch Events), SNS, and Terraform to create a notification system for AWS Health events. The project now also supports integration with Datadog for enhanced monitoring capabilities.

## Architecture Overview

The AWS Health Awareness (AHA) project is a streamlined notification system that monitors AWS Health events and delivers alerts via email. Using AWS native services and Terraform for deployment, AHA provides timely awareness of service issues, scheduled maintenance, and account-specific problems.

## Architecture Diagram

```
┌───────────────────┐     ┌───────────────────────┐     ┌───────────────┐
│                   │     │                       │     │               │
│ AWS Health Events │────►│ CloudWatch Events/    │────►│ SNS Topic     │────► Email Subscribers
│                   │     │ EventBridge           │     │               │
└───────────────────┘     └───────────────────────┘     └───────────────┘
                             │                            │
                             │                            │
                             └────────────────────────────┘
                                  Terraform Resources

                          ┌───────────────────────┐     
                          │                       │     
AWS Services ─────────────► Datadog IAM Role      │────► Datadog Platform
(Optional)                │ with Permissions      │     
                          │                       │     
                          └───────────────────────┘     
```

## Core Components

1. **AWS Health Service**: Provides visibility into performance and availability issues affecting your AWS resources.

2. **EventBridge Rule**: Monitors the AWS Health event stream and captures events matching configured patterns.

3. **SNS Topic**: Distributes notifications to subscribed email addresses when health events are detected.

4. **Datadog Integration (Optional)**: Allows for comprehensive monitoring of AWS resources, including AWS Health events, through the Datadog platform.

## Event Flow Process

1. When AWS detects an issue affecting your resources, AWS Health publishes an event.
2. The EventBridge rule captures events from the "aws.health" source.
3. Matching events are forwarded to the SNS topic.
4. The SNS topic sends email notifications to all confirmed subscriptions.
5. Recipients receive detailed information about the health event and can take appropriate action.
6. If Datadog integration is enabled, AWS Health events and other metrics are also available in Datadog dashboards.

## Key Features

- **Email Notifications**: Receive alerts directly in your inbox
- **Terraform Deployment**: Infrastructure-as-Code for consistent deployment
- **Subscription Management**: Easy addition and removal of notification recipients
- **Testing Capability**: Includes test event json for verification of the notification pipeline
- **Datadog Integration**: Optional component to send AWS metrics and events to Datadog

The included test event file (`health.json`) allows you to verify the entire notification pipeline before relying on it for production use. New email recipients will receive confirmation requests and must click the confirmation link to activate their subscription.

## Quick Start Guide

### Step 1: Copy the Project Folder

Copy the existing `aha-sns-member-account` folder which already contains all necessary files:
- `main.tf` - Contains the Terraform configuration
- `variables.tf` - Defines the required variables
- `terraform.tfvars` - Where you'll set your account-specific values
- `health.json` - A test event file

If you plan to use the Datadog integration, also include:
- `aws_datadog_integration.tf` - Contains the Terraform configuration for Datadog integration

### Step 2: Update Your Variables

Edit the `terraform.tfvars` file in the copied folder and update it with your account-specific values:

```hcl
# Basic AHA configuration
aws_account_id     = "123456789012"  # Replace with your actual AWS account ID
notification_emails = [
  "your-email@example.com",
  "team-email@example.com"
]

# Datadog integration (optional)
datadog_external_id = "a1b2c3d4-5678-90ab-cdef-EXAMPLE11111"  # Only if using Datadog
role_name = "DatadogAWSIntegrationRole"  # Optional, customize if needed
```

#### Obtaining the Datadog External ID

If you're setting up the Datadog integration, you'll need to obtain an External ID. This is a unique security identifier generated specifically for your AWS account integration:

1. **If you have direct Datadog access**:
   - Log in to your Datadog account
   - Navigate to Integrations → AWS
   - Click on the "New Installation" button
   - Select "Role Delegation" as the authentication method
   - In the configuration panel, you'll see an "External ID" field with a generated value
   - Copy this value for use in your `terraform.tfvars` file
   - Note: This ID is unique to this specific AWS account integration

2. **If you work with a centralized Datadog team**:
   - Contact your Datadog administrator
   - Provide your AWS Account ID
   - Request the External ID specifically for your AWS account integration
   - They will need to start the integration process and share the External ID with you

### Step 3: Deploy

Run the following commands to deploy the solution:

```bash
terraform init
terraform plan
terraform apply
```

### Step 4: Confirm Email Subscriptions

Each email address you specified will receive a confirmation email from AWS SNS. All recipients must click the confirmation link to activate their subscription and start receiving notifications.

### Step 5: Complete Datadog Integration (if applicable)

If you're using the Datadog integration:

1. Note the IAM role ARN from the Terraform output:
   ```
   datadog_integration_role_arn = "arn:aws:iam::123456789012:role/DatadogAWSIntegrationRole"
   ```

2. Provide this information to your Datadog administrator or complete the setup in Datadog:
   - Log in to Datadog
   - Go to Integrations → AWS
   - Complete the integration setup with your AWS Account ID and the Role ARN

## Testing the Setup

To test that everything is working correctly:

1. The project folder already includes a `health.json` file with a test event.

2. Send the test event using the AWS CLI:

```bash
aws events put-events --entries file://health.json
```

3. Check your email for the test notification.

4. If using Datadog, verify that AWS metrics are appearing in your Datadog account.

## Making Changes

### Adding or Removing Email Recipients

1. Edit the `notification_emails` list in your `terraform.tfvars` file
2. Run `terraform apply` again
3. New recipients will need to confirm their subscription

### Updating Datadog Integration Permissions

If Datadog needs additional permissions:

1. Update the policy in `aws_datadog_integration.tf`
2. Run `terraform apply` to update the role

## Troubleshooting

### Email Notifications Issues

If you're not receiving notifications:

1. Check that all email addresses have confirmed their subscriptions
2. Verify your AWS credentials have appropriate permissions
3. Check the CloudWatch Event Rule and SNS Topic in the AWS console

### Datadog Integration Issues

If Datadog isn't receiving data from your AWS account:

1. Verify the IAM role exists and has the correct permissions
2. Check that the trust relationship includes the correct External ID
3. Confirm the integration is properly configured in Datadog
4. Check for any error messages in the AWS CloudTrail logs related to AssumeRole calls