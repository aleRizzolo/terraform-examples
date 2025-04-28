resource "aws_docdbelastic_cluster" "db" {
  name                    = "${var.app_name}-docdb"
  admin_user_name         = var.admin_user_name
  admin_user_password     = var.admin_user_password
  auth_type               = var.auth_type
  shard_capacity          = 2
  shard_count             = 1
  backup_retention_period = var.retention_period
  subnet_ids              = var.subnet_ids
  vpc_security_group_ids  = var.docdb_security

  tags = {
    Name = "${var.app_name}-documentdb"
  }
}