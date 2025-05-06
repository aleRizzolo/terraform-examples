output "cache_reader_endpoint" {
  value = aws_elasticache_serverless_cache.redis_cache.reader_endpoint
}

output "cache_endpoint" {
  value = aws_elasticache_serverless_cache.redis_cache.endpoint
}