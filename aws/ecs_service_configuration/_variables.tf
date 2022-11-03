variable "private_subnets" {}

variable "security_groups" {}

variable "environment_name" {}

variable "environment_region" {}

variable "dns_zone_id" {}

variable "application_port" {}

variable "application_image" {}

variable "application_name" {}

variable "application_cpu" {}

variable "application_memory" {}

variable "application_url_entry" {}

variable "application_path" {}

variable "application_path_status_code" {
  default = "200-202"
}

#variable "ecs_cluster_name" {}

variable "ecs_cluster_id" {}

variable "ecs_cluster_arn" {}

variable "service_desired_count" {}

variable "service_min_capacity" {
  default = 2
}

variable "vpc_id" {}

variable "service_name" {}

variable "iam_role_arn" {}

variable "target_group_name" {}

variable "load_balancer_url" {}

variable "load_balancer_arn" {}

variable "load_balancer_arn_suffix" {}

variable "load_balancer_listener_arn" {}

variable "ecs_launch_type" {
  default = "FARGATE"
}

variable "ecs_container_definition" {
  default = "./container-definition.json.tpl"
}
