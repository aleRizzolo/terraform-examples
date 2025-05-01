output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_cidrs_id" {
  description = "Private subnet ids"
  value       = aws_subnet.private_subnets[*].id
}

output "db_subnet_id" {
  description = "List of IDs of private DB subnets"
  value = [
    for i, subnet in aws_subnet.private_subnets :
    subnet.id
    if floor(i / length(var.azs)) == 1 # Specifically targeting "private_db_subnet" at index 1
  ]
}