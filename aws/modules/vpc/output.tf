output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "lb_sg" {
  value = aws_security_group.nlb_sg.id
}

output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}

output "elasticache_sg" {
  value = aws_security_group.cache_sg.id
}

output "eip_allocation_id" {
  value = aws_eip.eip[*].allocation_id
}