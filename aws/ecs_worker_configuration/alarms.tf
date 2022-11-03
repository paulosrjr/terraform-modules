# Cloudwatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${local.env_no_dot}_${local.application_name}_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    ClusterName = var.ecs_cluster_id
    ServiceName = var.service_name
  }

  alarm_actions = ["${aws_appautoscaling_policy.this_scale_up.arn}"]
}

# Cloudwatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${local.env_no_dot}_${local.application_name}_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    ClusterName = var.ecs_cluster_id
    ServiceName = var.service_name
  }

  alarm_actions = ["${aws_appautoscaling_policy.this_scale_down.arn}"]
}
