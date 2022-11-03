variable "private_subnets" {}

variable "security_groups" {}

variable "environment_name" {}

variable "environment_region" {}

variable "application_port" {}

variable "application_image" {}

variable "application_name" {}

variable "application_cpu" {}

variable "application_memory" {}

#variable "ecs_cluster_name" {}

variable "ecs_cluster_id" {}

variable "ecs_cluster_arn" {}

variable "service_desired_count" {}

variable "vpc_id" {}

variable "service_name" {}

variable "iam_role_arn" {}

variable "ecs_launch_type" {
  default = "FARGATE"
}

variable "ecs_container_definition" {
  default = "./container-definition.json.tpl"
}
