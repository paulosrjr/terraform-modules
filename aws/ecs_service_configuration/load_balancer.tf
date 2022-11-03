resource "aws_lb_target_group" "this" {
  name        = local.target_group_name
  port        = local.application_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id
  deregistration_delay = 10

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = 2
    interval            = 15
    unhealthy_threshold = 8
    timeout             = 10
    path                = local.application_path
    port                = local.application_port
    matcher             = local.application_path_status_code
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = local.load_balancer_listener_arn


  lifecycle {
    create_before_destroy = false
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = ["${local.application_url_entry}.${local.env}"]
    }
  }
}
