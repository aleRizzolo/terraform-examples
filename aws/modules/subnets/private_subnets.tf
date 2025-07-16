resource "aws_subnet" "private_subnets" {
  # This creates 6 subnets: 3 subnet types across 2 AZs (private subnets needed: ecs, docdb, cache)
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
    nat_gateway_id = aws_nat_gateway.natgw[count.index].id
  }
  tags = {
    Name = "${var.app_name}-rt-private-${var.azs[count.index]}"
  }
}

# Associate route tables with ALL private subnets in each AZ
resource "aws_route_table_association" "association_private_subnets" {
  count = length(var.azs) * length(var.private_subnet_names)
  # This will associate ALL private subnets to their corresponding AZ's route table
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.nat_route[count.index % length(var.azs)].id
}