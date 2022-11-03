resource "aws_ecs_task_definition" "this" {
  family                   = "${local.env_no_dot}-${local.application_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.application_cpu
  memory                   = local.application_memory

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn      = aws_iam_role.app_role.arn

  container_definitions = var.ecs_container_definition

  skip_destroy = true

  tags = {
    Name = local.application_name
    Env  = local.env
    Tier = "private"
  }
}

resource "aws_ecs_service" "this" {
  name            = local.service_name
  cluster         = local.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = local.service_desired_count
  #iam_role        = local.iam_role_arn
  launch_type = var.ecs_launch_type

  network_configuration {
    security_groups  = local.security_groups
    subnets          = local.private_subnets
    assign_public_ip = false
  }

  tags = {
    Name = local.application_name
    Env  = local.env
    Tier = "private"
  }
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

}
