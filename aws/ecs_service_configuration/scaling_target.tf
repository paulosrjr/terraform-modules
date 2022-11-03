resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${local.env_no_dot}/${local.application_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = local.service_desired_count * 10
  min_capacity       = local.service_min_capacity
}
