# Config Grafana

resource "aws_lb_target_group" "grafana" {
  name        = "${local.env_no_dot}-grafana"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = local.vpc_id

  lifecycle {
    create_before_destroy = false
  }

  health_check {
    healthy_threshold   = 3
    interval            = 30
    unhealthy_threshold = 3
    timeout             = 25
    path                = "/login"
    port                = 3000
  }
}

resource "aws_lb_listener_rule" "grafana" {
  listener_arn = local.load_balancer_listener_arn


  lifecycle {
    create_before_destroy = false
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }

  condition {
    host_header {
      values = ["grafana.${var.env}"]
    }
  }
}

resource "aws_autoscaling_attachment" "grafana" {
  autoscaling_group_name = aws_autoscaling_group.promstack.id
  alb_target_group_arn   = aws_lb_target_group.grafana.arn
}

#resource "aws_route53_record" "grafana" {
#  zone_id = local.dns_zone_id
#  name    = "grafana.${local.dns_domain}"
#  type    = "CNAME"
#  ttl     = 60
#  records = [local.load_balancer_url]
#}

# Config Prometheus
# resource "aws_lb_target_group" "prometheus" {
#   name        = "${local.env_no_dot}-prometheus"
#   port        = 9090
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = local.vpc_id

#   lifecycle {
#     create_before_destroy = false
#   }

#   health_check {
#     healthy_threshold   = 3
#     interval            = 30
#     unhealthy_threshold = 3
#     timeout             = 25
#     path                = "/metrics"
#     port                = 9090
#   }
# }

# resource "aws_lb_listener_rule" "prometheus" {
#   listener_arn = local.load_balancer_listener_arn


#   lifecycle {
#     create_before_destroy = false
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.prometheus.arn
#   }

#   condition {
#     host_header {
#       values = ["prometheus.${var.env}"]
#     }
#   }
# }

# resource "aws_autoscaling_attachment" "prometheus" {
#   autoscaling_group_name = aws_autoscaling_group.promstack.id
#   alb_target_group_arn   = aws_lb_target_group.prometheus.arn
# }

# Config Alert Manager

# resource "aws_lb_target_group" "alertmanager" {
#   name        = "${local.env_no_dot}-alertmanager"
#   port        = 3000
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = local.vpc_id

#   lifecycle {
#     create_before_destroy = false
#   }

#   health_check {
#     healthy_threshold   = 3
#     interval            = 30
#     unhealthy_threshold = 3
#     timeout             = 25
#     path                = "/login"
#     port                = 3000
#   }
# }

# resource "aws_lb_listener_rule" "alertmanager" {
#   listener_arn = local.load_balancer_listener_arn


#   lifecycle {
#     create_before_destroy = false
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alertmanager.arn
#   }

#   condition {
#     host_header {
#       values = ["alertmanager.${var.env}"]
#     }
#   }
# }

# resource "aws_autoscaling_attachment" "alertmanager" {
#   autoscaling_group_name = aws_autoscaling_group.promstack.id
#   alb_target_group_arn   = aws_lb_target_group.alertmanager.arn
# }

