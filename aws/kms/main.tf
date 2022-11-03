resource "aws_kms_key" "this" {
  description             = "KMS key for ${var.environment_name} in ${var.environment_region} environment"
  deletion_window_in_days = 30

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.environment_name
    Env  = var.environment_region
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.environment_name}"
  target_key_id = aws_kms_key.this.key_id
}
