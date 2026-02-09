locals {
  # in the code, READER_ENDPOINT substitutes REDIS_URL (cache endpoint)
  # the code below is intended to fix this behaviour
  # aws uses port 6380 as alias. we could use cache_endpoint for all
  # if the code is fixed, change below and in task definition
  cache_endpoint  = "rediss://${var.cache_endpoint[0].address}:${var.cache_endpoint[0].port}/0?ssl_cert_reqs=none"
  reader_endpoint = "rediss://${var.cache_endpoint[0].address}:${var.cache_endpoint[0].port}/0?ssl_cert_reqs=none"
  cors_origin     = var.origin
}
