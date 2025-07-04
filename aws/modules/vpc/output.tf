output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "lb_sg" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}

output "docdb_sg" {
  value = aws_security_group.docdb_sg.id
}