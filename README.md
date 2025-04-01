# AWS Health Awareness (AHA) Project Documentation

## Overview

The AWS Health Awareness (AHA) project is a monitoring infrastructure designed to capture AWS Health events and route them to appropriate notification channels. It uses AWS EventBridge (CloudWatch Events), SNS, and Terraform to create a notification system for AWS Health events.

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
```

## Core Components

1. **AWS Health Service**: Provides visibility into performance and availability issues affecting your AWS resources.

2. **EventBridge Rule**: Monitors the AWS Health event stream and captures events matching configured patterns.

3. **SNS Topic**: Distributes notifications to subscribed email addresses when health events are detected.

## Event Flow Process

1. When AWS detects an issue affecting your resources, AWS Health publishes an event.
2. The EventBridge rule captures events from the "aws.health" source.
3. Matching events are forwarded to the SNS topic.
4. The SNS topic sends email notifications to all confirmed subscriptions.
5. Recipients receive detailed information about the health event and can take appropriate action.

## Key Features

- **Email Notifications**: Receive alerts directly in your inbox
- **Terraform Deployment**: Infrastructure-as-Code for consistent deployment
- **Subscription Management**: Easy addition and removal of notification recipients
- **Testing Capability**: Includes test event json for verification of the notification pipeline

The included test event file (`health.json`) allows you to verify the entire notification pipeline before relying on it for production use. New email recipients will receive confirmation requests and must click the confirmation link to activate their subscription.

## Quick Start Guide

### Step 1: Copy the Project Folder

Copy the existing `aha-sns-member-account` folder which already contains all necessary files:
- `main.tf` - Contains the Terraform configuration
- `variables.tf` - Defines the required variables
- `terraform.tfvars` - Where you'll set your account-specific values
- `health.json` - A test event file

### Step 2: Update Your Variables

Edit the `terraform.tfvars` file in the copied folder and update it with your AWS account ID and notification email addresses:

```hcl
aws_account_id     = "123456789012"  # Replace with your actual AWS account ID
notification_emails = [
  "your-email@example.com",
  "team-email@example.com"
]
```

### Step 3: Deploy

Run the following commands to deploy the solution:

```bash
terraform init
terraform plan
terraform apply
```

### Step 4: Confirm Email Subscriptions

Each email address you specified will receive a confirmation email from AWS SNS. All recipients must click the confirmation link to activate their subscription and start receiving notifications.

## Testing the Setup

To test that everything is working correctly:

1. The project folder already includes a `health.json` file with a test event.

2. Send the test event using the AWS CLI:

```bash
aws events put-events --entries file://health.json
```

3. Check your email for the test notification.

## Making Changes

### Adding or Removing Email Recipients

1. Edit the `notification_emails` list in your `terraform.tfvars` file
2. Run `terraform apply` again
3. New recipients will need to confirm their subscription

## Troubleshooting

If you're not receiving notifications:

1. Check that all email addresses have confirmed their subscriptions
2. Verify your AWS credentials have appropriate permissions
3. Check the CloudWatch Event Rule and SNS Topic in the AWS console