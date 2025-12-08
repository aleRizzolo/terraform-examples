resource "aws_docdb_cluster_instance" "cluster_instances" {
  count                        = length(var.azs)
  identifier                   = "${var.app_name}-dbinstance-${count.index}"
  cluster_identifier           = aws_docdb_cluster.db.id
  instance_class               = var.instance_class
  availability_zone            = var.azs[count.index]
  preferred_maintenance_window = var.preferred_maintenance_window
  enable_performance_insights  = true

  tags = {
    Name = "${var.app_name}-docdb-instance"
  }
}