resource "aws_route53_resolver_rule" "route53_resolver_rule" {
  name                 = var.resolver_rule_name
  domain_name          = var.domain_name
  rule_type            = var.rule_type
  resolver_endpoint_id = var.resolver_endpoint_id
  dynamic "target_ip" {
    for_each = var.target_ip != {} ? var.target_ip : {}
    content {
     ip          = target_ip.key
     port        = target_ip.value.port
    }
  }    
  tags = {
    Name        = var.resolver_rule_name
  }
}

resource "aws_route53_resolver_rule_association" "route53_resolver_rule_association" {
  for_each         = var.vpc_id
  resolver_rule_id = aws_route53_resolver_rule.route53_resolver_rule.id
  vpc_id           = each.value[0]
}