#tfsec:ignore:AWS086   #Ignore point in time recovery warnings
resource "aws_dynamodb_table" "tf_backend_state_lock" {

  name = var.dynamo_table_name

  read_capacity  = 1
  write_capacity = 1

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.this.arn
  }

  tags = local.common_tags
}
