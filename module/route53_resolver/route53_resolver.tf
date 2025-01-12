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