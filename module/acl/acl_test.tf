locals {
 test = {
 acl_name = "test"
 acl_vpc = "test-vpc"
 acl_subnets = ["sub-136-0-16","sub-136-192_208-1d-az2"]
 acl_ingress_rule = {100 = ["all", "deny","5.188.10.104/32",null,null],
                     101 = ["all", "deny","5.188.10.105/32",null,null],
                     140 = ["all", "allow","0.0.0.0/0",null,null]} 
    #ルール番号 = ["プロトコル", "許可/拒否allow/deny", "送信元cidr_block", "ポート範囲from_port", "ポート範囲to_port"]
 acl_egress_rule = {140 = ["all", "allow","0.0.0.0/0",null,null]}
 acl_environment = "test"
 acl_account = "test"
 acl_managedby = "test"
 acl_mapmigrated = "test"
 }
}

module "test" {
  source = "../../module/acl"

 acl_name = local.test.acl_name
 acl_vpc = local.test.acl_vpc
 acl_subnets = local.test.acl_subnets
 acl_ingress_rule = local.test.acl_ingress_rule
 acl_egress_rule = local.test.acl_egress_rule
 acl_environment = local.test.acl_environment
 acl_account = local.test.acl_account
 acl_managedby = local.test.acl_managedby
 acl_mapmigrated = local.test.acl_mapmigrated
}