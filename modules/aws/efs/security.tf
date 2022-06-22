data "aws_security_group" "efs_sg" {
  for_each = { for efs in var.efs_specs : efs.name => efs if efs.security_group_tags != null }
  tags     = each.value.security_group_tags
}

resource "aws_security_group" "efs_sg" {
  # checkov:skip=CKV2_AWS_5: attached to EFS
  for_each = { for efs in var.efs_specs : efs.name => efs if efs.efs_id == null && efs.security_group_tags == null }

  name        = "${var.project}-${each.value.name}-efs-sg"
  description = "Allow inbound traffic from solution servers to EFS"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${var.project}-${each.value.name}-efs-sg"
    },
    var.tags
  )
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "egress_efs_sg" {
  for_each = { for efs in var.efs_specs : efs.name => efs if efs.efs_id == null && efs.security_group_tags == null }

  description       = "Allow egress to all from EFS"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.efs_sg[each.value.name].id
}
