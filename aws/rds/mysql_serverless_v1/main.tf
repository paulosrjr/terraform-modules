data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix        = "${var.name}"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "this" {
  name        = var.name
  description = "Group of DB subnets for ${var.name}"
  subnet_ids  = var.subnets
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = var.name
  family      = "aurora-mysql5.7"
  description = "RDS default cluster parameter group for ${var.name}"

  lifecycle {
    create_before_destroy = true
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "server_audit_logging"
    value = "1"
  }

  parameter {
    name  = "server_audit_logs_upload"
    value = "1"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "performance_schema"
    value        = "1"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "performance_schema_consumer_events_stages_history_long"
    value        = "1"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "performance_schema_consumer_thread_instrumentation"
    value        = "1"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "performance_schema_consumer_global_instrumentation"
    value        = "1"
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = var.name

  engine         = "aurora-mysql"
  engine_version = var.engine_version
  engine_mode    = "serverless"

  database_name   = var.database_name
  master_username = var.username
  master_password = var.password

  apply_immediately = var.apply_immediately

  preferred_backup_window   = var.preferred_backup_window
  backup_retention_period   = var.backup_retention_period
  copy_tags_to_snapshot     = true
  final_snapshot_identifier = var.final_snapshot_identifier
  skip_final_snapshot       = true

  #enabled_cloudwatch_logs_exports = ["audit" ,"error", "general", "slowquery"]

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = var.security_groups

  scaling_configuration {
    auto_pause               = var.auto_pause
    seconds_until_auto_pause = var.seconds_until_auto_pause
    max_capacity             = var.max_capacity
    min_capacity             = var.min_capacity
    timeout_action           = "RollbackCapacityChange"
  }
}
