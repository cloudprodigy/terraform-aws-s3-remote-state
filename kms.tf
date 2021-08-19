resource "aws_kms_key" "this" {
  description             = "Terraform remote backend DDB Key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.common_tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.environment}-ddb-tf-key"
  target_key_id = aws_kms_key.this.key_id
}