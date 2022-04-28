data "aws_efs_file_system" "efs" {
  for_each       = { for efs in var.efs_specs : efs.name => efs if efs.efs_id != null }
  file_system_id = each.value.efs_id
}

resource "aws_efs_file_system" "efs" {
  # checkov:skip=CKV_AWS_184: Already encryted
  # checkov:skip=CKV_AWS_42: Already encryted
  # checkov:skip=CKV2_AWS_18: custom backup plan in effect
  for_each         = { for efs in var.efs_specs : efs.name => efs if efs.efs_id == null }
  creation_token   = "${var.project}-${each.value.name}-efs"
  performance_mode = each.value.performance_mode
  throughput_mode  = "bursting"
  encrypted        = try(each.value.encrypted, false) == true
  kms_key_id       = try(each.value.encrypted, false) == true ? data.aws_kms_key.efs_cmk[each.value.name].arn : null

  lifecycle_policy {
    transition_to_ia = each.value.transition_to_ia
  }

  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  tags = merge(
    {
      Name       = "${var.project}-${each.value.name}-efs"
      BackupPlan = each.value.backup_plan
    },
    var.tags
  )
}

# resource "aws_efs_backup_policy" "policy" {
#   for_each       = { for efs in var.efs_specs : efs.name => efs }
#   file_system_id = aws_efs_file_system.efs[each.value.name].id

#   backup_policy {
#     status = each.value.backup
#   }
# }

locals {
  efs = {
    for efs in var.efs_specs : efs.name => {
      name     = efs.name
      id       = efs.efs_id == null ? aws_efs_file_system.efs[efs.name].id : data.aws_efs_file_system.efs[efs.name].id
      arn      = efs.efs_id == null ? aws_efs_file_system.efs[efs.name].arn : data.aws_efs_file_system.efs[efs.name].arn
      dns_name = efs.efs_id == null ? aws_efs_file_system.efs[efs.name].dns_name : data.aws_efs_file_system.efs[efs.name].dns_name
      sg_id    = efs.security_group_tags != null ? data.aws_security_group.efs_sg[efs.name].id : efs.efs_id == null ? aws_security_group.efs_sg[efs.name].id : null
      sg_tags = efs.security_group_tags != null ? efs.security_group_tags : efs.efs_id == null ? aws_security_group.efs_sg[efs.name].tags : null
    }
  }
}

locals {
  efs_mount_targets = flatten([
    for efs in var.efs_specs : [
      for subnet_id in data.aws_subnets.subnets.ids : {
        name            = "${var.project}-${efs.name}-efs-${subnet_id}"
        create          = efs.efs_id == null
        efs_name        = efs.name
        subnet_id       = subnet_id
        security_groups = [local.efs[efs.name].sg_id]
      }
    ] if efs.efs_id == null
  ])
}

resource "aws_efs_mount_target" "efs_mount" {
  for_each        = { for efs_mount_target in local.efs_mount_targets : efs_mount_target.name => efs_mount_target if efs_mount_target.create }
  file_system_id  = aws_efs_file_system.efs[each.value.efs_name].id
  subnet_id       = each.value.subnet_id
  security_groups = each.value.security_groups
}

resource "aws_efs_access_point" "efs_ap" {
  for_each       = { for efs_ap in var.efs_access_point_specs : "${efs_ap.efs_name}-${efs_ap.efs_ap}" => efs_ap }
  file_system_id = local.efs[each.value.efs_name].id

  posix_user {
    uid = each.value.uid
    gid = each.value.gid
  }

  root_directory {
    path = each.value.root_path
    creation_info {
      owner_uid   = each.value.owner_uid
      owner_gid   = each.value.owner_gid
      permissions = each.value.root_permission
    }
  }

  tags = merge(
    {
      Name = each.value.efs_ap
    },
    var.tags
  )

  depends_on = [
    #force wait for mount creation
    aws_efs_mount_target.efs_mount
  ]
}

data "aws_efs_access_points" "efs_aps" {
  for_each       = { for efs in local.efs : efs.name => efs }
  file_system_id = each.value.id

  depends_on = [
    aws_efs_access_point.efs_ap
  ]
}

#efs resource policy
data "aws_iam_policy_document" "efs-policy" {
  for_each = { for efs in var.efs_specs : efs.name => efs }

  statement {
    sid = "AllowAccessOnMountTargetViaTLSOnly"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite"
    ]
    resources = [local.efs[each.value.name].arn]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "true"
      ]
    }
    condition {
      test     = "Bool"
      variable = "elasticfilesystem:AccessedViaMountTarget"
      values = [
        "true"
      ]
    }
  }

  # dynamic "statement" {
  #   for_each = [for efs_ap in var.efs_access_point_specs : efs_ap if efs_ap.efs_name == each.value.name]
  #   content {
  #     principals {
  #       type        = "AWS"
  #       identifiers = ["*"]
  #     }
  #     actions = [
  #       "elasticfilesystem:ClientRootAccess",
  #       "elasticfilesystem:ClientMount",
  #       "elasticfilesystem:ClientWrite"
  #     ]
  #     resources = [local.efs[each.value.name].arn]
  #     condition {
  #       test     = "StringEquals"
  #       variable = "elasticfilesystem:AccessPointArn"
  #       values   = [aws_efs_access_point.efs_ap["${each.value.name}-${statement.value.efs_ap}"].arn]
  #     }
  #   }
  # }

  dynamic "statement" {
    for_each = [for arn in data.aws_efs_access_points.efs_aps[each.value.name].arns : arn]
    content {
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      actions = [
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite"
      ]
      resources = [local.efs[each.value.name].arn]
      condition {
        test     = "StringEquals"
        variable = "elasticfilesystem:AccessPointArn"
        values   = [statement.value]
      }
    }
  }
}


#resource policy for EFS
resource "aws_efs_file_system_policy" "efs-policy" {
  for_each       = { for efs in var.efs_specs : efs.name => efs }
  file_system_id = local.efs[each.value.name].id

  bypass_policy_lockout_safety_check = false

  policy = data.aws_iam_policy_document.efs-policy[each.value.name].json
}
