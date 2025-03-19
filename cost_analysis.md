# Cost Analysis: AWS Health Aware (AHA) Solution

This document provides a cost estimate for implementing the AWS Health Aware solution using EventBridge and SNS, without utilizing Lambda for sending notifications.

## Components

1. Amazon EventBridge
2. Amazon SNS (Simple Notification Service)

## Pricing Breakdown

### 1. Amazon EventBridge

- Custom events: $1.00 per million events published
- AWS events (like AWS Health events): Free

### 2. Amazon SNS

- First 1 million Amazon SNS requests per month: Free
- $0.50 per 1 million Amazon SNS requests thereafter
- $0.06 per 100,000 HTTP/HTTPS deliveries
- $0.90 per 100,000 email deliveries

## Usage Scenario

Assuming a moderate usage scenario:
- 10,000 AWS Health events per month
- 1 email notification per event

## Cost Calculation

### EventBridge
- AWS Health events: Free

### SNS
- Requests: 10,000 events (within free tier)
- Email deliveries: (10,000 / 100,000) * $0.90 = $0.09

## Total Estimated Cost

**$0.09 per month**

## Additional Considerations

- This estimate is likely on the high side for most use cases. Actual AWS Health events are typically much lower in number.
- Other AWS services triggering events could increase EventBridge usage, but it would take a significant volume to exceed the free tier.
- SNS email costs remain minimal unless sending a very high volume of notifications.

## Conclusion

This solution is highly cost-effective for typical usage patterns. The primary factor that could increase costs would be processing an exceptionally high volume of events or sending a large number of notifications.