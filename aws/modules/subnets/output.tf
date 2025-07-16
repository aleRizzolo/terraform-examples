output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "db_subnet_id" {
  description = "List of IDs of private DB subnets"
  value = [
    for i, subnet in aws_subnet.private_subnets :
    subnet.id
    if floor(i / length(var.azs)) == 1 # Specifically targeting "private_db_subnet" at index 1
  ]
}

output "cache_subnet_ids" {
  description = "List of IDs of private ElastiCache subnets"
  value = [
    for i, subnet in aws_subnet.private_subnets :
    subnet.id
    if floor(i / length(var.azs)) == 2 # Specifically targeting "private_cache_subnet" at index 2
  ]
}

output "ecs_subnet_ids" {
  description = "IDs of private ECS subnets only"
  value = [
    for i, subnet in aws_subnet.private_subnets :
    subnet.id
    if floor(i / length(var.azs)) == 0 # Specifically targeting "private_ecs_subnet" at index 0
  ]
}

output "private_alb_subnets_id" {
  value = aws_subnet.lb_subnet[*].id
}