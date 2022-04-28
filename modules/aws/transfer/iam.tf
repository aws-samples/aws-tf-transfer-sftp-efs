data "aws_iam_policy_document" "transfer_assume_role" {
  count = local.create_sftp_logging_role ? 1 : 0

  statement {
    sid = "AllowAssumeRoleToTransferService"
    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "transfer_logging" {
  count = local.create_sftp_logging_role ? 1 : 0

  statement {
    sid = "TransferLoggingAccessPermissions"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/transfer/*:*"
    ]
  }
}

resource "aws_iam_policy" "transfer_logging" {
  count = local.create_sftp_logging_role ? 1 : 0

  name        = "${local.sftp_logging_role_name}-policy"
  description = "Policy that allows the SFTP server to log to CloudWatch"
  policy      = data.aws_iam_policy_document.transfer_logging[count.index].json
  #tags = var.tags
}

resource "aws_iam_role" "transfer_logging" {
  count = local.create_sftp_logging_role ? 1 : 0

  name               = local.sftp_logging_role_name
  description        = "This role is used by transfer service to log to CloudWatch"
  assume_role_policy = data.aws_iam_policy_document.transfer_assume_role[count.index].json
  #tags = var.tags
}

resource "aws_iam_role_policy_attachment" "transfer_logging" {
  count = local.create_sftp_logging_role ? 1 : 0

  role       = aws_iam_role.transfer_logging[count.index].name
  policy_arn = aws_iam_policy.transfer_logging[count.index].arn
}

data "aws_iam_role" "transfer_logging" {
  name = local.sftp_logging_role_name

  depends_on = [
    aws_iam_role.transfer_logging
  ]
}

data "aws_iam_policy_document" "transfer_user" {
  count = local.create_sftp_user_role ? 1 : 0

  statement {
    sid = "TransferUserReadWritePermissions"
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite"
    ]
    resources = [
      "arn:aws:elasticfilesystem:*:*:file-system/*",
    ]
  }
}

resource "aws_iam_policy" "transfer_user" {
  count = local.create_sftp_user_role ? 1 : 0

  name        = "${local.sftp_user_role_name}-policy"
  description = "Policy that allows read-write permission to EFS for the transfer service user"
  policy      = data.aws_iam_policy_document.transfer_user[count.index].json
  #tags = var.tags
}

resource "aws_iam_role" "transfer_user" {
  count = local.create_sftp_user_role ? 1 : 0

  name               = local.sftp_user_role_name
  description        = "This role can be assumed by SFTP user"
  assume_role_policy = data.aws_iam_policy_document.transfer_assume_role[count.index].json
  #tags = var.tags
}

resource "aws_iam_role_policy_attachment" "transfer_user" {
  count = local.create_sftp_user_role ? 1 : 0

  role       = aws_iam_role.transfer_user[count.index].name
  policy_arn = aws_iam_policy.transfer_user[count.index].arn
}

data "aws_iam_role" "transfer_user" {
  name = local.sftp_user_role_name

  depends_on = [
    aws_iam_role.transfer_user
  ]
}

data "aws_iam_policy_document" "lambda_assume_role" {
  count = local.create_sftp_lambda_role ? 1 : 0

  statement {
    sid = "AllowAssumeRoleToLambdaService"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "sftp_lambda" {
  # checkov:skip=CKV_AWS_111: recommended for lambda
  count = local.create_sftp_lambda_role ? 1 : 0

  statement {
    actions = [
      "lambda:GetFunctionConfiguration"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*:*",
      "arn:aws:logs:*:*:log-group:/aws/lambda-insights:*"
    ]
  }
  statement {
    actions = [
      "logs:StartQuery",
      "logs:GetQueryResults"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*:*"
    ]
  }
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "SNS:Publish"
    ]
    resources = [
      "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}

resource "aws_iam_policy" "sftp_lambda" {
  count = local.create_sftp_lambda_role ? 1 : 0

  name        = "${local.sftp_lambda_role_name}-policy"
  description = "Policy that allows Lambda Service access to CW and network"
  policy      = data.aws_iam_policy_document.sftp_lambda[count.index].json
  #tags = var.tags
}

resource "aws_iam_role" "sftp_lambda" {
  count = local.create_sftp_lambda_role ? 1 : 0

  name               = local.sftp_lambda_role_name
  description        = "This role is assumed by Lambda service for SFTP functions"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role[count.index].json
  #tags = var.tags
}

resource "aws_iam_role_policy_attachment" "sftp_lambda" {
  count = local.create_sftp_lambda_role ? 1 : 0

  role       = aws_iam_role.sftp_lambda[count.index].name
  policy_arn = aws_iam_policy.sftp_lambda[count.index].arn
}

data "aws_iam_role" "sftp_lambda" {
  name = local.sftp_lambda_role_name

  depends_on = [
    aws_iam_role.sftp_lambda
  ]
}
