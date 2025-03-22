resource "aws_subnet" "private_subnets" {
  # This creates 4 subnets: 2 subnet types across 2 AZs
  count      = length(var.azs) * length(var.private_subnet_names)
  vpc_id     = var.vpc_id
  cidr_block = var.private_cidrs[count.index]
  # Calculate the AZ index (0 or 1) based on the subnet index
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = {
    # Determine the subnet type name based on the index
    Name = "${var.app_name}-${var.private_subnet_names[floor(count.index / length(var.azs))]}-${var.azs[count.index % length(var.azs)]}"
  }
}

# Route tables for each AZ
resource "aws_route_table" "nat_route" {
  count  = length(var.azs)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_natgw[count.index].id
  }

  tags = {
    Name = "${var.app_name}-rt-private-${var.azs[count.index]}"
  }
}

# Associate route tables only with private_ecs_subnet in each AZ
resource "aws_route_table_association" "association_privatesubA" {
  count = length(var.azs)

  # This will pick only the private_ecs_subnet in each AZ
  subnet_id      = aws_subnet.private_subnets[count.index * length(var.private_subnet_names)].id
  route_table_id = aws_route_table.nat_route[count.index].id
}