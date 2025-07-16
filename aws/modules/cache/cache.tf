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

  daily_snapshot_time      = var.daily_snapshot_time
  description              = var.description
  major_engine_version     = "7"
  snapshot_retention_limit = var.snapshot_retention_limit
  security_group_ids       = var.sg_ids
  subnet_ids               = var.cache_subnet_ids

  tags = {
    Name = "${var.app_name}-elasticache-redis-cluster"
  }
}