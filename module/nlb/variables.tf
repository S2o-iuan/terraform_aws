variable "data_sg_name" {}
variable "subnet_mapping1" {
    default = null
}
variable "eip_mapping1" {
    default = null
}
variable "subnet_mapping2" {
    default = null
}
variable "eip_mapping2" {
    default = null
} 
variable "lb_name" {}
variable "lb_internal" {}
variable "lb_type" {}
variable "lb_account" {}
variable "lb_enviroment" {}
variable "lb_managedby" {}
variable "lb_map_migrated" {}
variable "lb_idle_timeout" {}
variable "has_lb_lister_rules_forward" {}
variable "lb_defalt_listener" {}
variable "lb_lister_rules_forward" {}
variable "lb_access_logs_enabled" {}
variable "lb_access_logs" {}
variable "lb_dns_record_client_routing_policy" {
    default = "any_availability_zone" 
}