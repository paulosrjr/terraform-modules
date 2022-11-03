locals {
  spot_max_price = sum([var.spot_price, 0.03])
}

data "template_file" "bastion" {
  template = file("${path.module}/templates/userdata.tpl")
  vars = {
    function  = "bastion"
    arguments = ""
  }
}

resource "aws_launch_template" "bastion" {
  name_prefix            = "bastion-"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t3.nano"
  key_name               = var.keyname
  vpc_security_group_ids = var.security_groups_id
  user_data              = base64encode(data.template_file.bastion.rendered)

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 18
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }
}

resource "aws_autoscaling_group" "bastion" {
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
        launch_template_id = aws_launch_template.bastion.id
        version            = "$Latest"
      }

      override {
        instance_type     = "t3a.nano"
        weighted_capacity = "2"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "bastion-${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "Public"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }
}
