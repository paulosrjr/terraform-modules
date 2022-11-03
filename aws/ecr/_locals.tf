locals {
  env                = var.environment_name
  name               = var.environment_name
  env_no_dot         = replace(var.environment_name, ".", "-")
  environment_region = var.environment_region
  environment_name   = var.environment_name
  application_name   = var.application_name
}
