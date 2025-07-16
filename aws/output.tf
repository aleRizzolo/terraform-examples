output "cloudfront_domain_name" {
  value = module.cloudfront.cf_domain_name
}

output "db_connection_string" {
  value = module.db.db_connection_string
}