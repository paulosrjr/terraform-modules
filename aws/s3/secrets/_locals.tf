locals {
  bucket_name   = var.bucket_name
  bucket_region = var.bucket_region
  name          = var.bucket_name
  env           = var.bucket_region
  bucket        = "${var.bucket_region}.${var.bucket_name}"
  bucket_no_dot    = replace(var.bucket_name, ".", "-")
}
