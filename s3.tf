resource "aws_s3_bucket" "tf_backend_bucket" { #tfsec:ignore:AWS002 tfsec:ignore:AWS017 tfsec:ignore:AWS077
  #ts:skip=AWS.S3Bucket.DS.High.1043 False positive, default is same account only
  bucket = "${var.account_id}-${var.bucket_name}"
  tags   = local.common_tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.tf_backend_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.tf_backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.tf_backend_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.tf_backend_bucket.id
  target_bucket = var.logging_bucket_name
  target_prefix = "${var.bucket_name}/tf-state/"
}

resource "aws_s3_bucket_policy" "tf_backend_bucket_policy" {
  bucket = aws_s3_bucket.tf_backend_bucket.id
  policy = data.aws_iam_policy_document.tf_backend_bucket_policy.json
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.tf_backend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}