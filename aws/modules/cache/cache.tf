resource "aws_elasticache_serverless_cache" "redis_cache" {
  engine = "redis"
  name   = "${var.app_name}-redis-cluster"

  cache_usage_limits {
    data_storage {
      minimum = var.minimum_cache_usage_limits
      maximum = var.maximum_cache_usage_limits
      unit    = "GB"
    }

    ecpu_per_second {
      minimum = var.minimum_ecpu_seconds
      maximum = var.maximum_ecpu_seconds
    }
  }

  daily_snapshot_time = var.daily_snapshot_time
  description         = var.description # describes the cache
  # kms_key_id               = aws_kms_key.test.arn NOTE: we use default aws key for at-rest encryption
  major_engine_version     = "7"
  snapshot_retention_limit = var.snapshot_retention_limit
  #security_group_ids       = [aws_security_group.test.id] # fix sg
  subnet_ids = var.cache_subnet_ids

  tags = {
    Name = "${var.app_name}-elasticache-redis-cluster"
  }
}