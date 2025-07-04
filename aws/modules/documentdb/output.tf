output "db_connection_string" {
  value = aws_docdbelastic_cluster.db.endpoint
}