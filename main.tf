resource "aws_cloudwatch_event_rule" "aha_health_events" {
  name        = "AHA-Health-Events-${var.aws_account_id}"
  description = "Capture AWS Health events and custom test events"

  event_pattern = jsonencode({
    source      = ["aws.health", "custom.health"]
    detail-type = ["AWS Health Event"]
  })
}

resource "aws_sns_topic" "aha_topic" {
  name = "AHA-Notifications-${var.aws_account_id}"
}

resource "aws_cloudwatch_event_target" "aha_sns_target" {
  rule      = aws_cloudwatch_event_rule.aha_health_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.aha_topic.arn
}

resource "aws_sns_topic_policy" "aha_topic_policy" {
  arn    = aws_sns_topic.aha_topic.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowEventBridgePublish"
        Effect    = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.aha_topic.arn
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "account_email_subscription" {
  for_each  = toset(var.notification_emails)
  topic_arn = aws_sns_topic.aha_topic.arn
  protocol  = "email"
  endpoint  = each.value
}

output "sns_topic_arn" {
  value = aws_sns_topic.aha_topic.arn
}
