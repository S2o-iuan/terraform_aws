terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = var.logs_name
  
  retention_in_days = var.logs_retention_days

  tags = {
    Name = var.logs_name
    Environment = var.logs_env
    Account = var.logs_account
    ManagedBy = var.logs_managedby
    map-migrated = var.logs_map_migrated
  }
}

resource "aws_cloudwatch_log_subscription_filter" "kinesis" {
  count = var.subscription_kinesis_filter_name != null ? 1 : 0
  
  name            = var.subscription_kinesis_filter_name
  destination_arn = var.subscription_kinesis_name != null ? data.aws_kinesis_firehose_delivery_stream.filter[count.index].arn : var.subscription_kinesis_arn
  filter_pattern  = ""
  log_group_name  = aws_cloudwatch_log_group.this.name

  # 以下オプション項目
  role_arn        = var.subscription_kinesis_iam_role_name != null ? data.aws_iam_role.filter[count.index].arn : null
}

data "aws_kinesis_firehose_delivery_stream" "filter" {
  count = var.subscription_kinesis_name != null ? 1 : 0
  name = var.subscription_kinesis_name
}

data "aws_iam_role" "filter" {
  count = var.subscription_kinesis_iam_role_name != null ? 1 : 0
  name = var.subscription_kinesis_iam_role_name
}

resource "aws_cloudwatch_log_subscription_filter" "lambda" {
  count = var.subscription_lambda_filter_name != null ? 1 : 0
  
  name            = var.subscription_lambda_filter_name
  destination_arn = data.aws_lambda_function.filter[count.index].arn
  filter_pattern  = ""
  log_group_name  = aws_cloudwatch_log_group.this.name

}

data "aws_lambda_function" "filter" {
  count = var.subscription_lambda_filter_name != null ? 1 : 0
  function_name = var.subscription_lambda_name
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count          = var.cloudwatch_log_stream_name != null ? 1 : 0
  name           = var.cloudwatch_log_stream_name
  log_group_name = aws_cloudwatch_log_group.this.name
}