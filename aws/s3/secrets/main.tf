terraform {
  required_providers {
    aws = "~> 4.36.1"
  }
}

resource "aws_kms_key" "this" {
  description             = "KMS key for secrets in ${local.name}"
  deletion_window_in_days = 30

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = local.bucket_name
    Env  = local.bucket_region
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${local.bucket_no_dot}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket
  acl    = "private"

  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name = local.bucket_name
    Env  = local.bucket_region
  }

  versioning {
    enabled = false
  }
}
