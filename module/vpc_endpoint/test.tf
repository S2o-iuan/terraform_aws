locals {
  vpc_endpoint_vpc                = ["vpc_2023-baku-test-az1-1c"]
  vpc_endpoint_service_name       = "com.amazonaws.ap-northeast-1.backup"
  vpc_endpoint_type               = "Interface"
  vpc_endpoint_dns_record_ip_type = "ipv4"
  vpc_endpoint_ip_address_type    = "ipv4"
  vpc_endpoint_subnets            = ["sub-136-0_16-1c", "baku-test-az2-1d"]
  vpc_endpoint_security_groups    = ["sg2024-baku-test-az1-1c-02", "sg2023-baku-test-1c"]
  vpc_endpoint_ipv4_address       = {"subnet-xxxxxxxxx" = ["10.136.0.12"], "subnet-xxxxxxxxxx" = ["10.136.16.12"]}
  vpc_endpoint_name               = "baku_test"
}


module "test" {
  source                          = "./module/vpc_endpoint"
  vpc_endpoint_vpc                = local.vpc_endpoint_vpc
  vpc_endpoint_service_name       = local.vpc_endpoint_service_name
  vpc_endpoint_type               = local.vpc_endpoint_type
  vpc_endpoint_dns_record_ip_type = local.vpc_endpoint_dns_record_ip_type
  vpc_endpoint_ip_address_type    = local.vpc_endpoint_ip_address_type
  vpc_endpoint_subnets            = local.vpc_endpoint_subnets
  vpc_endpoint_security_groups    = local.vpc_endpoint_security_groups
  vpc_endpoint_ipv4_address       = local.vpc_endpoint_ipv4_address
  vpc_endpoint_name               = local.vpc_endpoint_name
}