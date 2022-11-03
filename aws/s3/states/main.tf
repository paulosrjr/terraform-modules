terraform {
  required_providers {
    aws = "~> 4.36.1"
  }
}

resource "aws_kms_key" "this" {
  description             = "KMS key for general ${local.env} environment encryption"
  deletion_window_in_days = 30

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = local.env
    Env  = local.env
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${local.env_no_dot}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket
  acl    = "log-delivery-write"

  lifecycle {
    prevent_destroy = false
  }

  logging {
    target_bucket = local.bucket // self
    target_prefix = "logs/"
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
    Name = local.bucket
    Env  = local.env
  }

  versioning {
    enabled = true
  }
}
