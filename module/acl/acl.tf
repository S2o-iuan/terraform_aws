#vpc取得
data "aws_vpc" "acl_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.acl_vpc}"]
  }
}
#subnets取得
data "aws_subnets" "acl_subnets" {
  filter {
    name   = "tag:Name"
    values = var.acl_subnets
  }
}
resource "aws_network_acl" "main" {
  vpc_id     = data.aws_vpc.acl_vpc.id
  subnet_ids = data.aws_subnets.acl_subnets.ids
  tags = {
    Name         = var.acl_name
    Environment  = var.acl_environment
    Account      = var.acl_account
    ManagedBy    = var.acl_managedby
    map-migrated = var.acl_mapmigrated
  }
}

resource "aws_network_acl_rule" "acl_ingress_rule" {
  for_each       = var.acl_ingress_rule
  network_acl_id = aws_network_acl.main.id
  rule_number    = each.key
  egress         = false
  protocol       = each.value[0]
  rule_action    = each.value[1]
  cidr_block     = each.value[2]
  from_port      = each.value[3]
  to_port        = each.value[4]
}

resource "aws_network_acl_rule" "acl_egress_rule" {
  for_each       = var.acl_egress_rule
  network_acl_id = aws_network_acl.main.id
  rule_number    = each.key
  egress         = true
  protocol       = each.value[0]
  rule_action    = each.value[1]
  cidr_block     = each.value[2]
  from_port      = each.value[3]
  to_port        = each.value[4]
}