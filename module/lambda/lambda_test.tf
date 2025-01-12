locals {
  test = {
    ###### アーカイブファイル作成
    archive_file_type        = "zip"
    archive_file_source_file = "./sendevent_sqs_im2.py"
    archive_file_output_path = "sendevent_sqs_im2.zip"
    ###### Lambda作成
    lambda_function_name          = "lmd-test"
    lambda_function_description   = "JP1連携ツール（JP1イベント作成用）"
    lambda_function_architectures = ["x86_64"]
    lambda_function_iam_role      = "role_name"
    lambda_function_runtime       = "python3.11"
    lambda_function_handler       = "sendevent_sqs_im2.lambda_handler"
    lambda_function_memory_size   = "128"
    lambda_function_storage       = 512
    lambda_function_timeout       = "60"
    # logging設定
    lambda_log_format = "Text"
    lambda_log_group  = "/aws/lambda/LambdaStack-AWSSDKforJavaScriptv2LambdaFunction1D5-Ek2q9gcrKyFj"
    # 環境変数
    environment_variables = {
      SQS_GROUPID_BY_RANDOM = "True"
    }
    # vpc設定                               
    lambda_subnet_ids          = ["subnet01", "subnet02"]
    lambda_security_groups_ids = ["sg-xxxxxxxxx"]
    ###### Lambdaトリガー作成
    # 一意のステートメント識別子
    lambda_permission_statement_id = null
    # このステートメントで許可する AWS Lambda アクション
    lambda_permission_action = ""
    # のアクセス許可を取得するプリンシパル
    lambda_permission_principal = ""
    # 特定のリソースの ARN に権限を付与(EventBridge ルールのARN)
    lambda_permission_source_arn = null
    # sqsトリガー設定    
    # sqs_arn = [トリガーをアクティブ化, バッチサイズ - オプション]}      
    sqs_trigger = {
      "sqs_arn01" = [true, 10],
      "sqs_arn02" = [true, 10]
    }
  }
}

module "test" {
  source = "./module/lambda"

  archive_file_type              = local.test.archive_file_type
  archive_file_source_file       = local.test.archive_file_source_file
  archive_file_output_path       = local.test.archive_file_output_path
  lambda_function_description    = local.test.lambda_function_description
  lambda_function_name           = local.test.lambda_function_name
  lambda_function_architectures  = local.test.lambda_function_architectures
  lambda_function_iam_role       = local.test.lambda_function_iam_role
  lambda_function_runtime        = local.test.lambda_function_runtime
  lambda_function_handler        = local.test.lambda_function_handler
  lambda_function_memory_size    = local.test.lambda_function_memory_size
  lambda_function_storage        = local.test.lambda_function_storage
  lambda_function_timeout        = local.test.lambda_function_timeout
  lambda_log_format              = local.test.lambda_log_format
  lambda_log_group               = local.test.lambda_log_group
  environment_variables          = local.test.environment_variables
  lambda_permission_statement_id = local.test.lambda_permission_statement_id
  lambda_permission_action       = local.test.lambda_permission_action
  lambda_permission_principal    = local.test.lambda_permission_principal
  lambda_permission_source_arn   = local.test.lambda_permission_source_arn
  lambda_subnet_ids              = local.test.lambda_subnet_ids
  lambda_security_groups_ids     = local.test.lambda_security_groups_ids
  sqs_trigger                    = local.test.sqs_trigger
}