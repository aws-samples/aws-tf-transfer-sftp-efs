resource "aws_security_group" "sftp_sg" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  count = local.create_sftp_sg ? 1 : 0

  name        = "${var.project}-${var.sftp_specs.server_name}-sftp-sg"
  description = "Allow inbound traffic from source to SFTP server"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${var.project}-${var.sftp_specs.server_name}-sftp-sg"
    },
    var.tags
  )
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress_sftp_sg" {
  count = local.create_sftp_sg ? 1 : 0

  description       = "Allow inbound traffic from source to SFTP server"
  type              = "ingress"
  from_port         = var.sftp_specs.security_group.sftp_port
  to_port           = var.sftp_specs.security_group.sftp_port
  protocol          = "tcp"
  cidr_blocks       = var.sftp_specs.security_group.source_cidrs
  security_group_id = aws_security_group.sftp_sg[0].id
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "egress_sftp_sg" {
  count = local.create_sftp_sg ? 1 : 0

  description       = "Allow egress to all from SFTP Server"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sftp_sg[0].id
}

data "aws_security_group" "sftp_sg" {
  id   = local.create_sftp_sg ? aws_security_group.sftp_sg[0].id : null
  tags = local.create_sftp_sg ? null : var.sftp_specs.security_group.tags
}

resource "aws_security_group" "lambda_sg" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  count = local.create_lambda_sg ? 1 : 0

  name        = "${local.sftp_lambda_name}-sg"
  description = "Allow outbound traffic from lambda to VPC"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${local.sftp_lambda_name}-sg"
    },
    var.tags
  )
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress_lambda_sg" {
  count = local.create_lambda_sg ? 1 : 0

  description              = "Allow ingress from the same SG"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.lambda_sg[0].id
  security_group_id        = aws_security_group.lambda_sg[0].id
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "egress_lambda_sg" {
  count = local.create_lambda_sg ? 1 : 0

  description       = "Allow egress to all from Lambda"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_sg[0].id
}

data "aws_security_group" "lambda_sg" {
  id   = local.create_lambda_sg ? aws_security_group.lambda_sg[0].id : null
  tags = local.create_lambda_sg ? null : var.sftp_specs.lambda_specs.security_group_tags
}

data "aws_security_group" "sftp_efs" {
  id   = local.create_efs_sg ? module.transfer_efs[0].efs["transfer-${var.sftp_specs.server_name}"].sg_id : null
  tags = local.create_efs_sg ? null : var.sftp_specs.efs_specs.security_group_tags
}

resource "aws_security_group_rule" "allow_lambda_ingress_to_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  description              = "Allow Lambda access to the EFS"
  security_group_id        = data.aws_security_group.sftp_efs.id
  source_security_group_id = data.aws_security_group.lambda_sg.id
}
