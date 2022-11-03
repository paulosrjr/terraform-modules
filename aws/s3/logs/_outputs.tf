output "bucket" {
  value = aws_s3_bucket.this.bucket
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "kms_key_alias" {
  value = aws_kms_alias.this.id
}
