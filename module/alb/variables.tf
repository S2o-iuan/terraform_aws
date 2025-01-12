variable "data_sg_name" {}
variable "data_subnet_name_list" {}
variable "lb_name" {}
variable "lb_internal" {}
variable "lb_type" {}
variable "lb_account" {}
variable "lb_enviroment" {}
variable "lb_managedby" {}
variable "lb_map_migrated" {}
variable "lb_idle_timeout" {}
variable "lb_defalt_listener" {}
variable "has_lb_lister_rules_forward" {}
variable "lb_lister_rules_forward" {}
variable "enable_xff_client_port" {}
variable "lb_access_logs" {}
variable "lb_connection_logs_enabled" {}
variable "lb_connection_logs" {}
variable "has_lb_lister_rules_header" {
    default = false
}
variable "lb_lister_rules_header" {
    default = null
}
variable "has_lb_lister_rules_ip" {
    default = false
}
variable "lb_lister_rules_ip" {
    default = null
}
variable "has_lb_lister_certificate" {
    default = false
}
variable "lb_lister_certificate" {
    default = null
}