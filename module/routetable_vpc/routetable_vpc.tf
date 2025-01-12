data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}
data "aws_ec2_transit_gateway" "tgw" {
  count    = var.transit_gateway_name != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.transit_gateway_name}"]
  }
}
data "aws_vpc_peering_connections" "peering" {
  for_each = var.has_peering_route ? var.peering_route : {}
  filter {
    name   = "tag:Name"
    values = ["${each.value[1]}"]
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route" "transit_gateway_route" {
  route_table_id              = aws_route_table.route_table.id
  destination_cidr_block      = var.transit_gateway_route_cidr_block
  transit_gateway_id          = data.aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "peering_route" {
  for_each                    = var.has_peering_route ? var.peering_route : {}
  route_table_id              = aws_route_table.route_table.id
  destination_cidr_block      = each.value[0]
  vpc_peering_connection_id   = data.aws_vpc_peering_connections.peering["${each.key}"].id
}