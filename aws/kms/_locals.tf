locals {
  env        = var.environment_name
  bucket     = "${var.environment_region}.${var.environment_name}.tfstate"
  env_no_dot = replace(var.environment_name, ".", "-")
}
