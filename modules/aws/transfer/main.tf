resource "aws_transfer_server" "sftp" {
  endpoint_type          = "VPC"
  security_policy_name   = "TransferSecurityPolicy-2020-06"
  protocols              = ["SFTP"]
  domain                 = "EFS"
  identity_provider_type = "SERVICE_MANAGED"

  force_destroy = true

  endpoint_details {
    vpc_id             = data.aws_vpc.vpc.id
    subnet_ids         = data.aws_subnets.subnets.ids
    security_group_ids = [data.aws_security_group.sftp_sg.id]
    #Do we need EIP
    #address_allocation_ids = []
  }

  logging_role = data.aws_iam_role.transfer_logging.arn

  tags = merge(
    {
      Name = "${var.project}-sftp-server-${var.sftp_specs.server_name}"
    },
    var.tags
  )
}

#needed for output and R53
data "aws_vpc_endpoint" "sftp" {
  id = aws_transfer_server.sftp.endpoint_details[0].vpc_endpoint_id
}

resource "aws_transfer_user" "sftp_user" {
  for_each  = { for sftp_user in var.sftp_users : sftp_user.name => sftp_user }
  server_id = aws_transfer_server.sftp.id
  user_name = each.value.name
  role      = data.aws_iam_role.transfer_user.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${local.efs.efs_id}${local.efs_ap_root}/${aws_transfer_server.sftp.id}/home/${each.value.name}"
  }
  posix_profile {
    uid = each.value.uid
    gid = each.value.gid
  }

  tags = merge(
    {
      Name = each.value.name
    },
    var.tags
  )

  depends_on = [
    aws_cloudwatch_event_rule.create_user,
    aws_cloudwatch_event_target.create_user_log,
    aws_cloudwatch_event_target.create_user_lambda,
    aws_lambda_function.sftp_lambda
  ]
}

resource "aws_transfer_ssh_key" "sftp_user_key" {
  for_each  = { for sftp_user in var.sftp_users : sftp_user.name => sftp_user }
  server_id = aws_transfer_server.sftp.id
  user_name = aws_transfer_user.sftp_user[each.value.name].user_name
  body      = file(each.value.ssh_key_file)
}

# R53 entry for SFTP server
resource "aws_route53_record" "sftp_rec" {
  count = local.create_r53_record ? 1 : 0

  zone_id         = data.aws_route53_zone.pvt_zone[count.index].zone_id
  name            = "${var.sftp_specs.server_name}.${data.aws_route53_zone.pvt_zone[count.index].name}"
  allow_overwrite = true
  type            = "A"
  alias {
    name                   = data.aws_vpc_endpoint.sftp.dns_entry[0].dns_name
    zone_id                = data.aws_vpc_endpoint.sftp.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_cloudwatch_log_group" "transfer_logs" {
  name              = "/aws/transfer/${aws_transfer_server.sftp.id}"
  retention_in_days = 7
  kms_key_id        = local.logs_kms_key_id

  tags = merge(
    {
      Name = "${var.project}-${var.sftp_specs.server_name}-sftp-logs"
    },
    var.tags
  )
}
