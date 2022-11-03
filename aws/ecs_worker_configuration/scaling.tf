resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${local.env_no_dot}/${local.application_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = local.service_desired_count * 2
  min_capacity       = 2
}

resource "aws_appautoscaling_policy" "this_scale_up" {
  name               = "${local.env_no_dot}-${local.application_name}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 10
    }
  }
}

resource "aws_appautoscaling_policy" "this_scale_down" {
  name               = "${local.env_no_dot}-${local.application_name}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

#resource "aws_appautoscaling_policy" "scale_by_request_up" {
#  name               = "${local.application_name}-request-up"
#  policy_type        = "TargetTrackingScaling"
#  resource_id        = aws_appautoscaling_target.this.resource_id
#  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.this.service_namespace
#
#  target_tracking_scaling_policy_configuration {
#    target_value       = 120
#    disable_scale_in   = false
#    scale_in_cooldown  = 60
#    scale_out_cooldown = 60
#
#    predefined_metric_specification {
#      # See https://docs.aws.amazon.com/pt_br/autoscaling/plans/APIReference/API_PredefinedScalingMetricSpecification.html
#      predefined_metric_type = "ALBRequestCountPerTarget"
#      resource_label         = "${local.load_balancer_listener_arn}/${aws_lb_target_group.this.arn_suffix}"
#    }
#  }
#}

resource "aws_appautoscaling_scheduled_action" "this_scale_schedule" {
  name               = "${local.env_no_dot}-${local.application_name}-scale-schedule"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  schedule           = "cron(0 6 * * ? *)"

  scalable_target_action {
    min_capacity = 1
    max_capacity = 30
  }
}
