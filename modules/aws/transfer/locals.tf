locals {
  encrypt_logs            = try(var.sftp_specs.encryption.encrypt_logs, false) ? true : false
  encrypt_lambda          = try(var.sftp_specs.encryption.encrypt_lambda, false) ? true : false
  encrypt_sns             = try(var.sftp_specs.encryption.encrypt_sns, false) ? true : false
  create_logs_kms_alias   = try(length(var.sftp_specs.encryption.logs_kms_alias), 0) == 0 && local.encrypt_logs ? true : false
  create_lambda_kms_alias = try(length(var.sftp_specs.encryption.lambda_kms_alias), 0) == 0 && local.encrypt_lambda ? true : false
  create_sns_kms_alias    = try(length(var.sftp_specs.encryption.sns_kms_alias), 0) == 0 && local.encrypt_sns ? true : false
  create_kms              = local.create_logs_kms_alias || local.create_lambda_kms_alias || local.create_sns_kms_alias ? true : false

  keys_to_create = compact([
    local.create_logs_kms_alias ? "logs" : "",
    local.create_lambda_kms_alias ? "lambda" : "",
    local.create_sns_kms_alias ? "sns" : "",
  ])

  logs_kms_alias   = local.create_logs_kms_alias ? "alias/${var.project}/logs" : try(var.sftp_specs.encryption.logs_kms_alias, "alias/${var.project}/logs")
  lambda_kms_alias = local.create_lambda_kms_alias ? "alias/${var.project}/lambda" : try(var.sftp_specs.encryption.lambda_kms_alias, "alias/${var.project}/lambda")
  sns_kms_alias    = local.create_sns_kms_alias ? "alias/${var.project}/sns" : try(var.sftp_specs.encryption.sns_kms_alias, "alias/${var.project}/sns")
}

locals {
  create_r53_record = try(length(var.r53_zone_name), 0) == 0 ? false : true
  create_efs        = var.sftp_specs.efs_specs.efs_id == null || var.sftp_specs.efs_specs.efs_ap_id == null
  create_efs_sg     = var.sftp_specs.efs_specs.efs_id == null && var.sftp_specs.efs_specs.security_group_tags == null
  create_sftp_sg    = length(try(var.sftp_specs.security_group.source_cidrs, [])) != 0 ? true : false
  create_lambda_sg  = try(length(var.sftp_specs.lambda_specs.security_group_tags), 0) == 0 ? true : false
  #If cron expression is availalbe, create report
  create_daily_report           = try(length(var.sftp_specs.lambda_specs.daily_report_schedule_expression), 0) != 0 ? true : false
  create_user_automation_report = try(length(var.sftp_user_automation_subscribers), 0) > 0 ? true : false

  create_sftp_user_role    = try(length(var.sftp_specs.user_role), 0) == 0 ? true : false
  create_sftp_logging_role = try(length(var.sftp_specs.logging_role), 0) == 0 ? true : false
  create_sftp_lambda_role  = try(length(var.sftp_specs.lambda_specs.execution_role), 0) == 0 ? true : false
  sftp_user_role_name      = local.create_sftp_user_role ? "CustomerManaged-${var.project}-sftp-user-${var.sftp_specs.server_name}" : var.sftp_specs.user_role
  sftp_logging_role_name   = local.create_sftp_logging_role ? "CustomerManaged-${var.project}-sftp-logging-${var.sftp_specs.server_name}" : var.sftp_specs.logging_role
  sftp_lambda_role_name    = local.create_sftp_lambda_role ? "CustomerManaged-${var.project}-sftp-lambda-${var.sftp_specs.server_name}" : var.sftp_specs.lambda_specs.execution_role

  sftp_lambda_name   = "${var.project}-sftp-user-automation-${var.sftp_specs.server_name}"
  report_lambda_name = "${var.project}-sftp-daily-report-${var.sftp_specs.server_name}"
}

locals {
  efs = {
    efs_id    = local.create_efs ? module.transfer_efs[0].efs_ap["${var.sftp_specs.server_name}_ap"].efs_id : var.sftp_specs.efs_specs.efs_id
    efs_ap_id = local.create_efs ? module.transfer_efs[0].efs_ap["${var.sftp_specs.server_name}_ap"].efs_ap_id : var.sftp_specs.efs_specs.efs_ap_id
  }
}

locals {
  efs_ap_root = local.create_efs ? "/${var.env_name}/${var.project}/sftp/${var.sftp_specs.server_name}" : data.aws_efs_access_point.sftp_efs_ap.root_directory[0].path
}

locals {
  logs_kms_key_id   = local.encrypt_logs ? data.aws_kms_key.logs_cmk[0].arn : null
  lambda_kms_key_id = local.encrypt_lambda ? data.aws_kms_key.lambda_cmk[0].arn : null
  sns_kms_key_id    = local.encrypt_sns ? data.aws_kms_key.sns_cmk[0].arn : null
}
