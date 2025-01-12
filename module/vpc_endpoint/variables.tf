variable "vpc_endpoint_type" {}
variable "vpc_endpoint_vpc" {}
variable "vpc_endpoint_service_name" {}
variable "vpc_endpoint_ip_address_type" {
    default = null
}
variable "vpc_endpoint_subnets" {
    default = []
}
variable "vpc_endpoint_security_groups" {
    default = []
}
variable "vpc_endpoint_dns_record_ip_type" {
    default = null
}
variable "vpc_endpoint_ipv4_address" {
    default = {}
}
variable "vpc_endpoint_name" {}
variable "vpc_endpoint_route_table_ids" {
    default = []
}
variable "private_dns_for_inbound" {
    default = false
}
variable "vpc_endpoint_private_dns_enabled" {
    default = true
}