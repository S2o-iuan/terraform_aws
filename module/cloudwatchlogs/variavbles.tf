variable "logs_name" {}
variable "logs_retention_days" {}
variable "logs_env" {}
variable "logs_account" {}
variable "logs_managedby" {}
variable "logs_map_migrated" {}
variable "subscription_kinesis_filter_name" {}
variable "subscription_kinesis_name" {}
variable "subscription_kinesis_arn" {}
variable "subscription_kinesis_iam_role_name" {}
variable "subscription_lambda_filter_name" {}
variable "subscription_lambda_name" {}
variable "cloudwatch_log_stream_name" {
    default = null
}