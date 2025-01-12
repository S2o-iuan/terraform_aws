locals {
  route53_resolver_test = {
    resolver_rule_name   = "test"
    domain_name          = "xxxxxxx.com"
    resolver_endpoint_id = "rslvr-out-xxxxxxxxxx"
    target_ip = {
      "10.136.68.6" = { port = 53 }
      "10.136.69.6" = { port = 53 }
    }
    vpc_id = { vpc1 = ["vpc-xxxxxxxxxx"],
               vpc2 = ["vpc-xxxxxxxxxx"] }
  }
}

module "route53_resolver_test" {
  source               = "./module/route53_resolver"
  resolver_rule_name   = local.route53_resolver_test.resolver_rule_name
  domain_name          = local.route53_resolver_test.domain_name
  resolver_endpoint_id = local.route53_resolver_test.resolver_endpoint_id
  target_ip            = local.route53_resolver_test.target_ip
  vpc_id               = local.route53_resolver_test.vpc_id
}