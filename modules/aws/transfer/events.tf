#CreateUser event on the transfer familty
resource "aws_cloudwatch_event_rule" "create_user" {
  name           = "${var.project}-${var.sftp_specs.server_name}-sftp-create-user"
  description    = "CreateUser event for each new user created for the SFTP server ${aws_transfer_server.sftp.id}"
  event_bus_name = "default"
  #role_arn       = aws_iam_role.aws_events_service_role.arn

  event_pattern = <<EOF
{
  "source": ["aws.transfer"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["transfer.amazonaws.com"],
    "eventName": ["CreateUser"],
    "requestParameters": {
      "serverId": ["${aws_transfer_server.sftp.id}"]
    }
  }
}
EOF

  tags = merge(
    {
      Name = "${var.project}-${var.sftp_specs.server_name}-sftp-create-user"
    },
    var.tags
  )
}

#This is to test if events are flowing, this can be removed later
resource "aws_cloudwatch_log_group" "transfer_events" {
  name              = "/aws/events/transfer/${var.project}-${var.sftp_specs.server_name}"
  retention_in_days = 7
  kms_key_id        = local.logs_kms_key_id

  tags = merge(
    {
      Name = "${var.project}-sftp-events"
    },
    var.tags
  )
}

data "aws_cloudwatch_log_group" "transfer_events" {
  name = "/aws/events/transfer/${var.project}-${var.sftp_specs.server_name}"

  depends_on = [
    aws_cloudwatch_log_group.transfer_events
  ]
}

# This is required for Event to be logged to the CW logs by Event Bus
data "aws_iam_policy_document" "events_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/events/transfer/*:*"]
    principals {
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "events_logs" {
  policy_document = data.aws_iam_policy_document.events_logs.json
  policy_name     = "trust-events-to-log-${var.project}-${var.sftp_specs.server_name}"
}

#This is to test if events are flowing, this can be removed later
resource "aws_cloudwatch_event_target" "create_user_log" {
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.create_user.name
  target_id      = "create-user-log"

  arn = data.aws_cloudwatch_log_group.transfer_events.arn
  #role_arn = "do we need role for log"

  retry_policy {
    maximum_event_age_in_seconds = 120
    maximum_retry_attempts       = 3
  }

  # TODO dead letter queue
  # dead_letter_config {
  #   arn = ""
  # }
}

resource "aws_cloudwatch_event_target" "create_user_lambda" {
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.create_user.name
  target_id      = "create_user_lambda"

  arn = aws_lambda_function.sftp_lambda.arn

  retry_policy {
    maximum_event_age_in_seconds = 120
    maximum_retry_attempts       = 3
  }

  # TODO dead letter queue
  # dead_letter_config {
  #   arn = ""
  # }
}
