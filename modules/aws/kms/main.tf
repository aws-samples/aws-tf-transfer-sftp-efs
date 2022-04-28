resource "aws_kms_key" "kms_key" {
  # checkov:skip=CKV_AWS_7: Rotation is usage driven
  for_each                 = toset(var.kms_config.keys_to_create)
  description              = "KMS key for encrypting ${each.value}"
  deletion_window_in_days  = 7
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy                   = local.policies[each.value]
  is_enabled               = true
  enable_key_rotation      = var.kms_config.enable_key_rotation

  tags = merge(
    {
      Name = "${var.kms_config.prefix}-${each.value}-cmk"
    },
    var.tags
  )
}

resource "aws_kms_alias" "kms_alias" {
  for_each = toset(var.kms_config.keys_to_create)

  name          = "alias/${var.kms_config.prefix}/${each.value}"
  target_key_id = aws_kms_key.kms_key[each.value].key_id
}
