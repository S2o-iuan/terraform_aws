# 関数ファイルからアーカイブを生成する
data "archive_file" "lambda" {
  type          = var.archive_file_type
  source_file   = var.archive_file_source_file
  output_path   = var.archive_file_output_path
}

# IAMロール呼び出す
data "aws_iam_role" "self" {
  name          = var.lambda_function_iam_role
}


# Lambda関数作成
resource "aws_lambda_function" "lambda" {
  description       = var.lambda_function_description 
  function_name     = var.lambda_function_name
  architectures     = var.lambda_function_architectures
  filename          = var.archive_file_output_path
  role              = data.aws_iam_role.self.arn
  runtime           = var.lambda_function_runtime
  handler           = var.lambda_function_handler
  memory_size       = var.lambda_function_memory_size
  timeout           = var.lambda_function_timeout
  ephemeral_storage {
    size            = "${var.lambda_function_storage}"
  }
  logging_config {
    log_format      = "${var.lambda_log_format}"
    log_group       = "${var.lambda_log_group}"
  }
  environment {
    variables       = "${var.environment_variables}" 
    }
  vpc_config{
    subnet_ids         = "${var.lambda_subnet_ids}"
    security_group_ids = "${var.lambda_security_groups_ids}"
  }  
  tags = {
    Name            = "${var.lambda_function_name}"
  }
}

# Lambdaトリガー作成
resource "aws_lambda_permission" "eventbridge" {
  count         = var.lambda_permission_principal != "" ? 1 : 0
  statement_id  = var.lambda_permission_statement_id
  action        = var.lambda_permission_action  
  function_name = aws_lambda_function.lambda.function_name
  principal     = var.lambda_permission_principal
  source_arn    = var.lambda_permission_source_arn
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  for_each         = var.sqs_trigger
  function_name    = aws_lambda_function.lambda.function_name
  event_source_arn = each.key
  enabled          = each.value[0]
  batch_size       = each.value[1]
}