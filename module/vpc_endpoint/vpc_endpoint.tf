data "aws_vpc" "vpc_endpoint_vpc" {
  filter {
    name   = "tag:Name"
    values = var.vpc_endpoint_vpc
  }
}
#subnets取得
data "aws_subnets" "vpc_endpoint_subnets" {
  count = var.vpc_endpoint_type != [] ? 1 : 0
  filter {
    name   = "tag:Name"
    values = var.vpc_endpoint_subnets
  }
}
#sg取得
data "aws_security_groups" "vpc_endpoint_security_groups" {
  count = var.vpc_endpoint_type == "Interface" ? 1 : 0
    filter {
    name   = "group-name"
    values = var.vpc_endpoint_security_groups
  }  
}

#interface_endpoint
resource "aws_vpc_endpoint" "vpc_interface_endpoint" {
  count               = var.vpc_endpoint_type == "Interface" ? 1 : 0
  vpc_id              = data.aws_vpc.vpc_endpoint_vpc.id
  service_name        = var.vpc_endpoint_service_name
  vpc_endpoint_type   = var.vpc_endpoint_type
  subnet_ids          = data.aws_subnets.vpc_endpoint_subnets[0].ids
  ip_address_type     = var.vpc_endpoint_ip_address_type
  private_dns_enabled = var.vpc_endpoint_private_dns_enabled

  dns_options {
    dns_record_ip_type = var.vpc_endpoint_dns_record_ip_type
    private_dns_only_for_inbound_resolver_endpoint = var.private_dns_for_inbound
  }
  dynamic "subnet_configuration" {
    for_each = var.vpc_endpoint_ipv4_address != {} ? var.vpc_endpoint_ipv4_address : {}
    content {
     subnet_id          = subnet_configuration.key
     ipv4               = subnet_configuration.value[0]
    }
  }
  security_group_ids = data.aws_security_groups.vpc_endpoint_security_groups[0].ids

  tags = {
    Name = "${var.vpc_endpoint_name}"
  }
}

#gateway_endpoint
resource "aws_vpc_endpoint" "vpc_gateway_endpoint" {
  count             = var.vpc_endpoint_type == "Gateway" ? 1 : 0
  vpc_id            = data.aws_vpc.vpc_endpoint_vpc.id
  service_name      = var.vpc_endpoint_service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  route_table_ids   = var.vpc_endpoint_route_table_ids


  tags = {
    Name = "${var.vpc_endpoint_name}"
  }
}