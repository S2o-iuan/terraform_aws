variable "resolver_rule_name" {}
variable "domain_name" {}
variable "resolver_endpoint_id" {}
variable "target_ip" {}
variable "rule_type" {
    default = "FORWARD"
}
variable "vpc_id" {}