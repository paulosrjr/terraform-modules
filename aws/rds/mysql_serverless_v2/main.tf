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
resource "aws_db_parameter_group" "this" {
  name        = "${local.env_no_dot}-${local.local_name}-v2"
  family      = "aurora-mysql8.0"
  description = "${local.env_no_dot}-${local.local_name}-v2"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${local.env_no_dot}-${local.local_name}-v2"
  family      = "aurora-mysql8.0"
  description = "${local.env_no_dot}-${local.local_name}-v2"
  tags        = local.tags
}

module "aurora_mysql_serverlessv2" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds-aurora"

  name                = "${local.env_no_dot}-${local.local_name}-v2"
  engine              = "aurora-mysql"
  engine_mode         = "provisioned"
  engine_version      = "8.0.mysql_aurora.3.02.0"
  storage_encrypted   = true
  publicly_accessible = false

  master_username       = data.sops_file.secret.data["database_user"]
  master_password       = data.sops_file.secret.data["database_password"]
  copy_tags_to_snapshot = true
  database_name         = "lms_dev"

  vpc_id                = data.aws_vpc.this.id
  subnets               = [for subnet in data.aws_subnet.database : subnet.id]
  create_security_group = true
  allowed_cidr_blocks   = ["0.0.0.0/0"]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.this.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 1
    auto_pause               = true
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
    two = {}
  }

  tags = {
    Name = "${local.env_no_dot}-${local.local_name}-v2"
    Env  = local.env
  }
}
