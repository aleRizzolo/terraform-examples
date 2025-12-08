output "db_connection_string" {
  value     = "mongodb://${aws_docdb_cluster.db.master_username}:${aws_docdb_cluster.db.master_password}@${aws_docdb_cluster.db.endpoint}:${aws_docdb_cluster.db.port}/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
  sensitive = true
}