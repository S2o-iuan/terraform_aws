variable "sqs_name" {}
variable "visibility_timeout_seconds" {}
variable "delay_seconds" {}
variable "max_message_size" {}
variable "message_retention_seconds" {}
variable "receive_wait_time_seconds" {}
variable "fifo_queue" {}
variable "content_based_deduplication" {}
variable "deduplication_scope" {}
variable "fifo_throughput_limit" {}
variable "sqs_managed_sse_enabled" {}
variable "redrive_allow_policy" {}
variable "redrive_allow_policy_permission" {}
variable "redrive_allow_policy_queue_arn" {}
variable "dead_letter_queue" {}
variable "dead_letter_queue_arn" {}
variable "dead_letter_queue_max_receive_count" {}
variable "send_user_arn_or_account" {}
variable "receiver_user_arn_or_account" {}
variable "basic_policy" {
    default = true
}
variable "advance_policy" {
    default = false
}
variable "sqs_advance_policy" {
    default = null
}