data "template_file" "promstack" {
  template = file("${path.module}/templates/userdata.tpl")
  vars = {
    function       = "promstack"
    external_label = var.env
    thanos_bucket  = var.thanos_bucket
    arguments      = ""
  }
}

resource "aws_launch_template" "promstack" {
  name_prefix            = "promstack-"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t3.large"
  key_name               = var.keyname
  vpc_security_group_ids = concat(var.security_groups_id, [aws_security_group.this.id])
  user_data              = base64encode(data.template_file.promstack.rendered)

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 60
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }
}

resource "aws_autoscaling_group" "promstack" {
  desired_capacity    = var.runner_qnty
  max_size            = var.runner_qnty
  min_size            = var.runner_qnty
  vpc_zone_identifier = var.subnets_id

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 0
      #on_demand_percentage_above_base_capacity = 100
      spot_allocation_strategy = "lowest-price"
      spot_max_price           = local.spot_max_price
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.promstack.id
        version            = "$Latest"
      }

      override {
        instance_type     = "t3a.large"
        weighted_capacity = "2"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "promstack-${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "Private"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }
}

resource "random_integer" "minute" {
  min = 00
  max = 60
}

#resource "aws_autoscaling_schedule" "stop" {
#  scheduled_action_name  = local.off_instance_name
#  min_size               = 0
#  max_size               = 0
#  desired_capacity       = 0
#  start_time             = "${local.today_timestamp}"
#  recurrence             = "${random_integer.minute.result} 01 * * *"
#  autoscaling_group_name = aws_autoscaling_group.promstack.name
#  lifecycle {
#    #ignore_changes = [start_time]
#    create_before_destroy = false
#  }
#  depends_on = [
#    aws_autoscaling_group.promstack,
#    data.template_file.promstack,
#  ]
#}
#
#resource "aws_autoscaling_schedule" "start" {
#  scheduled_action_name  = local.on_instance_name
#  min_size               = var.runner_qnty
#  max_size               = var.runner_qnty
#  desired_capacity       = var.runner_qnty
#  start_time             = "${local.today_timestamp}"
#  recurrence             = "${random_integer.minute.result} 11 * * MON-FRI"
#  autoscaling_group_name = aws_autoscaling_group.promstack.name
#  lifecycle {
#    #ignore_changes = [start_time]
#    create_before_destroy = false
#  }
#  depends_on = [
#    aws_autoscaling_group.promstack,
#    data.template_file.promstack,
#  ]
#}
