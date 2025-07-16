output "db_connection_string" {
  value = aws_docdb_cluster.db.endpoint
}