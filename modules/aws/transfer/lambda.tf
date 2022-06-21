resource "aws_cloudwatch_log_group" "lambda_insights" {
  count = var.create_common_logs ? 1 : 0

  name              = "/aws/lambda-insights"
  retention_in_days = 7
  kms_key_id        = local.logs_kms_key_id

  tags = merge(
    {
      Name = "${var.project}-lambda-insights"
    },
    var.tags
  )
}

resource "aws_cloudwatch_log_group" "sftp_lambda_logs" {
  name              = "/aws/lambda/${local.sftp_lambda_name}"
  retention_in_days = 7
  kms_key_id        = local.logs_kms_key_id

  tags = merge(
    {
      Name = "${local.sftp_lambda_name}-logs"
    },
    var.tags
  )
}

data "archive_file" "sftp_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/files/sftp_user_automation.py"
  output_path = "./.temp/sftp_user_automation.zip"
}

# data "aws_lambda_layer_version" "lambda_insights" {
#   layer_name              = "LambdaInsightsExtension"
#   compatible_architecture = "arm64"
#   #compatible_runtime      = "python3.9"
# }

resource "aws_lambda_function" "sftp_lambda" {
  # checkov:skip=CKV_AWS_116: DLQ will be added TODO
  function_name = local.sftp_lambda_name
  role          = data.aws_iam_role.sftp_lambda.arn
  description   = "Lambda to automate SFTP user folder maintenance"

  package_type     = "Zip"
  filename         = data.archive_file.sftp_lambda_zip.output_path
  source_code_hash = data.archive_file.sftp_lambda_zip.output_base64sha256
  handler          = "sftp_user_automation.lambda_handler"
  runtime          = "python3.9"

  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 10
  #use unreserved
  reserved_concurrent_executions = 1

  publish = true

  kms_key_arn = local.lambda_kms_key_id
  environment {
    variables = {
      ENVIRONMENT         = upper(var.env_name)
      FILE_SYSTEM_ID      = data.aws_efs_file_system.sftp_efs.id
      SFTP_SERVER_ID      = aws_transfer_server.sftp.id
      SFTP_DNS            = local.create_r53_record ? "${var.sftp_specs.server_name}.${var.r53_zone_name}" : var.sftp_specs.server_name
      BASE_PATH           = "/${local.efs.efs_id}${local.efs_ap_root}"
      LOCAL_MOUNT_PATH    = "/mnt/sftp"
      EXCEPTION_SNS_TOPIC = local.create_user_automation_report ? aws_sns_topic.sftp_lambda[0].arn : ""
    }
  }

  file_system_config {
    arn              = data.aws_efs_access_point.sftp_efs_ap.arn
    local_mount_path = "/mnt/sftp"
  }

  vpc_config {
    subnet_ids         = data.aws_subnets.subnets.ids
    security_group_ids = [data.aws_security_group.lambda_sg.id]
  }

  tracing_config {
    mode = "Active"
  }

  layers = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension-Arm64:1"]

  #   dead_letter_config {
  #   }

  tags = merge(
    {
      Name = local.sftp_lambda_name
    },
    var.tags
  )

  depends_on = [
    aws_cloudwatch_log_group.sftp_lambda_logs
  ]
}

resource "aws_lambda_permission" "sftp_lambda" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sftp_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.create_user.arn
  #qualifier     = "aws_lambda_alias.test_alias.name"
}

resource "aws_sns_topic" "sftp_lambda" {
  count = local.create_user_automation_report ? 1 : 0

  name         = local.sftp_lambda_name
  display_name = "${upper(var.env_name)} SFTP User Automation Topic"

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
      Name = local.sftp_lambda_name
    },
    var.tags
  )
}

resource "aws_sns_topic_subscription" "sftp_lambda" {
  for_each  = { for email in var.sftp_user_automation_subscribers : email => email }
  topic_arn = aws_sns_topic.sftp_lambda[0].arn
  protocol  = "email"
  endpoint  = each.value

  endpoint_auto_confirms = false

  #filter_policy        = ""
}
