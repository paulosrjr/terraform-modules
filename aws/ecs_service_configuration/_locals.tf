locals {
  env                = var.environment_name
  name               = var.environment_name
  bucket             = "${var.environment_region}.${var.environment_name}"
  env_no_dot         = replace(var.environment_name, ".", "-")
  private_subnets    = var.private_subnets
  security_groups    = var.security_groups
  environment_region = var.environment_region
  environment_name   = var.environment_name
  dns_domain         = var.environment_name
  dns_zone_id        = var.dns_zone_id
}

locals {
  application_port           = var.application_port
  application_image          = var.application_image
  application_name           = var.application_name
  application_cpu            = var.application_cpu
  application_memory         = var.application_memory
  application_url_entry      = var.application_url_entry
  application_path           = var.application_path
  application_path_status_code = var.application_path_status_code
  ecs_cluster_id             = var.ecs_cluster_id
  ecs_cluster_arn            = var.ecs_cluster_arn
  service_desired_count      = var.service_desired_count
  service_min_capacity       = var.service_min_capacity
  vpc_id                     = var.vpc_id
  service_name               = var.service_name
  iam_role_arn               = var.iam_role_arn
  target_group_name          = var.target_group_name
  load_balancer_url          = var.load_balancer_url
  load_balancer_arn          = var.load_balancer_arn
  load_balancer_listener_arn = var.load_balancer_listener_arn
  load_balancer_arn_suffix = var.load_balancer_arn_suffix
}
