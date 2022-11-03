locals {
  spot_max_price             = sum([var.spot_price, 0.03])
  today_date                 = formatdate("YYYY-MM-DD", timestamp())
  today_time                 = formatdate("23:mm:ss", timestamp())
  today_timestamp            = "${local.today_date}T${local.today_time}Z"
  name_with_timestamp        = formatdate("YYYYMMDDhhmmss", timestamp())
  off_instance_name          = "off_instance_${local.name_with_timestamp}"
  on_instance_name           = "on_instance_${local.name_with_timestamp}"
  env                        = var.env
  load_balancer_listener_arn = var.load_balancer_listener_arn
  vpc_id                     = var.vpc_id
  env_no_dot                 = replace(var.env, ".", "-")
}
