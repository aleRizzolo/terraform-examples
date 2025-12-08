locals {
  db_name = "myapp-db-dev"
}

resource "aws_docdb_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-docdb-subnet-groups"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.app_name}-documentdb-subnet-groups"
  }
}

resource "aws_docdb_cluster" "db" {
  cluster_identifier              = local.db_name
  master_username                 = var.admin_user_name
  master_password                 = var.admin_user_password
  backup_retention_period         = var.retention_period
  vpc_security_group_ids          = var.docdb_security
  availability_zones              = var.azs
  db_subnet_group_name            = aws_docdb_subnet_group.db_subnet_group.name
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  storage_encrypted               = true
  kms_key_id                      = data.aws_kms_key.by_alias.arn
  engine_version                  = "8.0"

  lifecycle {
    ignore_changes = [cluster_identifier]
  }

  tags = {
    Name = "${var.app_name}-documentdb"
  }
}