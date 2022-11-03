#resource "aws_appautoscaling_scheduled_action" "this_scale_schedule" {
#  name               = "${local.env_no_dot}-${local.application_name}-scale-schedule"
#  service_namespace  = aws_appautoscaling_target.this.service_namespace
#  resource_id        = aws_appautoscaling_target.this.resource_id
#  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#  schedule           = "cron(0 6 * * ? *)"
#
#  scalable_target_action {
#    min_capacity = 2
#    max_capacity = local.service_desired_count * 2
#  }
#}
