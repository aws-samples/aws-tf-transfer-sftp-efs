resource "aws_cloudwatch_log_group" "report_lambda_logs" {
  count = local.create_daily_report ? 1 : 0

  name              = "/aws/lambda/${local.report_lambda_name}"
  retention_in_days = 7
  kms_key_id        = local.logs_kms_key_id

  tags = merge(
    {
      Name = "${local.report_lambda_name}-logs"
    },
    var.tags
  )
}

data "archive_file" "report_lambda_zip" {
  count = local.create_daily_report ? 1 : 0

  type        = "zip"
  source_file = "${path.module}/files/sftp_daily_report.py"
  output_path = "./.temp/sftp_daily_report.zip"
}

resource "aws_lambda_function" "report_lambda" {
  count = local.create_daily_report ? 1 : 0

  # checkov:skip=CKV_AWS_117: VPC Lambda is not required
  # checkov:skip=CKV_AWS_116: DLQ will be added TODO
  function_name = local.report_lambda_name
  role          = data.aws_iam_role.sftp_lambda.arn
  description   = "Lambda to send daily report on SFTP usage"

  package_type     = "Zip"
  filename         = data.archive_file.report_lambda_zip[count.index].output_path
  source_code_hash = data.archive_file.report_lambda_zip[count.index].output_base64sha256
  handler          = "sftp_daily_report.lambda_handler"
  runtime          = "python3.9"

  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 15
  #use unreserved
  reserved_concurrent_executions = 1

  publish = true

  kms_key_arn = local.lambda_kms_key_id
  environment {
    variables = {
      ENVIRONMENT        = var.env_name
      TRANSFER_LOG_GROUP = aws_cloudwatch_log_group.transfer_logs.name
      TOPIC_ARN          = aws_sns_topic.sftp_daily_report[count.index].arn
    }
  }

  # VPC not needed
  #  vpc_config {
  #    subnet_ids         = data.aws_subnets.subnets.ids
  #    security_group_ids = [data.aws_security_group.lambda_sg.id]
  #  }

  tracing_config {
    mode = "Active"
  }

  layers = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension-Arm64:1"]

  #   dead_letter_config {
  #   }

  tags = merge(
    {
      Name = local.report_lambda_name
    },
    var.tags
  )

  depends_on = [
    aws_cloudwatch_log_group.report_lambda_logs
  ]
}

resource "aws_lambda_permission" "report_lambda" {
  count = local.create_daily_report ? 1 : 0

  statement_id  = "AllowExecutionFromEventBridgeToReportLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.report_lambda[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.create_daily_report[count.index].arn
  #qualifier     = "aws_lambda_alias.test_alias.name"
}

resource "aws_cloudwatch_event_rule" "create_daily_report" {
  count = local.create_daily_report ? 1 : 0

  name           = "${var.project}-${var.sftp_specs.server_name}-sftp-create-daily-report"
  description    = "Initiate Lambda to generate SFTP Daily Report for the SFTP server ${aws_transfer_server.sftp.id}"
  event_bus_name = "default"
  #role_arn       = aws_iam_role.aws_events_service_role.arn
  schedule_expression = var.sftp_specs.lambda_specs.daily_report_schedule_expression

  tags = merge(
    {
      Name = "${var.project}-${var.sftp_specs.server_name}-sftp-create-daily-report"
    },
    var.tags
  )
}

resource "aws_cloudwatch_event_target" "report_lambda" {
  count = local.create_daily_report ? 1 : 0

  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.create_daily_report[count.index].name
  target_id      = "daily_report_lambda"

  arn = aws_lambda_function.report_lambda[count.index].arn
  #role_arn = "do we need role for lambda"

  input_transformer {
    input_paths = {
      time   = "$.time",
      region = "$.region"
    }
    input_template = <<EOF
    {
      "params": {
        "trigger": "Schedule",
        "time": <time>,
        "region": <region>
      }
    }
    EOF
  }

  retry_policy {
    maximum_event_age_in_seconds = 120
    maximum_retry_attempts       = 3
  }

  # TODO dead letter queue
  # dead_letter_config {
  #   arn = ""
  # }

  depends_on = [
    aws_lambda_permission.report_lambda
  ]
}

resource "aws_sns_topic" "sftp_daily_report" {
  count = local.create_daily_report ? 1 : 0

  name         = local.report_lambda_name
  display_name = "${upper(var.env_name)} SFTP Daily Report Topic"

  kms_master_key_id = local.sns_kms_key_id

  fifo_topic = false

  #resource policy
  #policy = "TODO"

  # N/A
  #delivery_policy = ""

  # No application target
  #application_success_feedback_role_arn = ""
  #application_success_feedback_sample_rate = ""
  #application_failure_feedback_role_arn = ""

  # No http target
  #http_success_feedback_role_arn = ""
  #http_success_feedback_sample_rate = ""
  #http_failure_feedback_role_arn = ""

  # No lambda target
  #lambda_success_feedback_role_arn = ""
  #lambda_success_feedback_sample_rate = ""
  #lambda_failure_feedback_role_arn = ""

  # No SQS target
  #sqs_success_feedback_role_arn = ""
  #sqs_success_feedback_sample_rate = ""
  #sqs_failure_feedback_role_arn = ""

  tags = merge(
    {
      Name = local.report_lambda_name
    },
    var.tags
  )
}

data "aws_iam_policy_document" "sftp_daily_report" {
  count = local.create_daily_report ? 1 : 0

  policy_id = "__default_policy_ID"

  statement {
    sid = "__default_statement_ID"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:Publish",
      "SNS:Receive",
      "SNS:Subscribe",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
    ]
    resources = [
      aws_sns_topic.sftp_daily_report[count.index].arn
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
  }
}

resource "aws_sns_topic_policy" "sftp_daily_report" {
  count = local.create_daily_report ? 1 : 0

  arn    = aws_sns_topic.sftp_daily_report[count.index].arn
  policy = data.aws_iam_policy_document.sftp_daily_report[count.index].json
}

resource "aws_sns_topic_subscription" "sftp_daily_report" {
  for_each  = { for email in(local.create_daily_report ? var.sftp_daily_report_subscribers : []) : email => email }
  topic_arn = aws_sns_topic.sftp_daily_report[0].arn
  protocol  = "email"
  endpoint  = each.value

  endpoint_auto_confirms = false

  #filter_policy        = ""
  lifecycle {
    ignore_changes = [
      # Ignore changes to the value, as it might have changed outside of TF
      pending_confirmation
    ]
  }
}
