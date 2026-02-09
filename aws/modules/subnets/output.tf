output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "cache_subnet_ids" {
  description = "List of IDs of private ElastiCache subnets"
  value = [
    for i, subnet in aws_subnet.private_subnets :
    subnet.id
    if floor(i / length(var.azs)) == 1 # specifically targeting "private_cache_subnet" at index 1
  ]
}

output "ecs_subnet_ids" {
  description = "IDs of private ECS subnets only"
  value = [
    for i, subnet in aws_subnet.private_subnets :
    subnet.id
    if floor(i / length(var.azs)) == 0 # specifically targeting "private_ecs_subnet" at index 0
  ]
}

output "private_lb_subnets_id" {
  value = aws_subnet.lb_subnet[*].id
}

output "private_route_table_ids" {
  description = "Private route table IDs for VPC endpoints"
  value       = aws_route_table.nat_route[*].id
}