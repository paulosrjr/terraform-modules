#resource "aws_appautoscaling_policy" "this_scale_up" {
#  name               = "${local.env_no_dot}-${local.application_name}-scale-up"
#  policy_type        = "StepScaling"
#  resource_id        = aws_appautoscaling_target.this.resource_id
#  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.this.service_namespace
#
#  step_scaling_policy_configuration {
#    adjustment_type         = "ChangeInCapacity"
#    cooldown                = 60
#    metric_aggregation_type = "Maximum"
#
#    step_adjustment {
#      metric_interval_upper_bound = 0
#      scaling_adjustment          = 10
#    }
#  }
#
#    depends_on = ["aws_appautoscaling_target.this"]
#}
#
#resource "aws_appautoscaling_policy" "this_scale_down" {
#  name               = "${local.env_no_dot}-${local.application_name}-scale-down"
#  policy_type        = "StepScaling"
#  resource_id        = aws_appautoscaling_target.this.resource_id
#  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.this.service_namespace
#
#  step_scaling_policy_configuration {
#    adjustment_type         = "ChangeInCapacity"
#    cooldown                = 60
#    metric_aggregation_type = "Maximum"
#
#    step_adjustment {
#      metric_interval_upper_bound = 0
#      scaling_adjustment          = -1
#    }
#  }
#
#    depends_on = ["aws_appautoscaling_target.this"]
#}
