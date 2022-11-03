#resource "aws_appautoscaling_policy" "request_up" {
#  name               = "${local.env_no_dot}-${local.application_name}-scaleup"
#  policy_type        = "TargetTrackingScaling"
#  resource_id        = aws_appautoscaling_target.this.resource_id
#  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.this.service_namespace
#
#  target_tracking_scaling_policy_configuration {
#    target_value       = 512
#    disable_scale_in   = false
#    scale_in_cooldown  = 60
#    scale_out_cooldown = 60
#
#    predefined_metric_specification {
#      # See https://docs.aws.amazon.com/pt_br/autoscaling/plans/APIReference/API_PredefinedScalingMetricSpecification.html
#      predefined_metric_type = "ALBRequestCountPerTarget"
#      resource_label         = "${local.load_balancer_arn_suffix}/${aws_lb_target_group.this.arn_suffix}"
#    }
#  }
#}
