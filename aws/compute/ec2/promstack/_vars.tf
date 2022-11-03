variable "runner_qnty" {
  default = 1
}

variable "region" {
  default = "us-east-2"
}

variable "env" {}

variable "keyname" {
  default = "ghactions"
}

variable "vpc_id" {}

variable "subnets_id" {}

variable "security_groups_id" {}

variable "spot_price" {
  default = 0.05
}

variable "thanos_bucket" {}

variable "load_balancer_listener_arn" {}
