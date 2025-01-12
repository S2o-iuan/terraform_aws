variable "archive_file_type" {}
variable "archive_file_source_file" {}
variable "archive_file_output_path" {}
variable "lambda_function_description" {}
variable "lambda_function_name" {}
variable "lambda_function_architectures" {}
variable "lambda_function_iam_role" {}
variable "lambda_function_runtime" {}
variable "lambda_function_handler" {}
variable "lambda_function_storage" {}
variable "lambda_function_memory_size" {}
variable "lambda_function_timeout" {}
variable "lambda_log_format" {}
variable "lambda_log_group" {} 
variable "environment_variables" {
    type = map(string)
    default = {}
}
variable "lambda_permission_statement_id" {}
variable "lambda_permission_action" {}
variable "lambda_permission_principal" {}
variable "lambda_permission_source_arn" {}
variable "lambda_subnet_ids" {
    default = []
}
variable "lambda_security_groups_ids" {
    default = []
}
variable "sqs_trigger" {
   default = {}
}