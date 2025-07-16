resource "aws_docdb_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-docdb-subnet-groups"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.app_name}-documentdb-subnet-groups"
  }
}

resource "aws_docdb_cluster" "db" {
  cluster_identifier           = "${var.app_name}-docdb"
  master_username              = var.admin_user_name
  master_password              = var.admin_user_password
  backup_retention_period      = var.retention_period
  vpc_security_group_ids       = var.docdb_security
  availability_zones           = var.azs
  db_subnet_group_name         = aws_docdb_subnet_group.db_subnet_group.name
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  tags = {
    Name = "${var.app_name}-documentdb"
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = length(var.azs)
  identifier         = "${var.app_name}-dbinstance-${count.index}"
  cluster_identifier = aws_docdb_cluster.db.id
  instance_class     = var.instance_class
  availability_zone  = var.azs[count.index]

  tags = {
    Name = "${var.app_name}-docdb-instance"
  }
}