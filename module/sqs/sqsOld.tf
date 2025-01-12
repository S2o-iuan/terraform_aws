# sqs構築
resource "aws_sqs_queue" "sqs_queue" {
  name                        = var.sqs_name
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  delay_seconds               = var.delay_seconds
  max_message_size            = var.max_message_size 
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  fifo_queue                  = var.fifo_queue #true
  content_based_deduplication = var.content_based_deduplication#true
  deduplication_scope         = var.deduplication_scope#"messageGroup"
  fifo_throughput_limit       = var.fifo_throughput_limit#"perMessageGroupId"
  sqs_managed_sse_enabled     = var.sqs_managed_sse_enabled#true

  tags = {
    Name = var.sqs_name
  }
}

# 許可ポリシーの再実行設定
resource "aws_sqs_queue_redrive_allow_policy" "redrive_allow_policy" {
  count = var.redrive_allow_policy == true ? 1 : 0
  queue_url = aws_sqs_queue.sqs_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "${var.redrive_allow_policy_permission}",#"byQueue",
    sourceQueueArns   = ["${var.redrive_allow_policy_queue_arn}"]
  })
}
# デッドレターキュー設定
resource "aws_sqs_queue_redrive_policy" "dead_letter_queue" {
  count = var.dead_letter_queue == true ? 1 : 0
  queue_url = aws_sqs_queue.sqs_queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = "${var.dead_letter_queue_arn}"
    maxReceiveCount     = "${var.dead_letter_queue_max_receive_count}"
  })
}

# アカウントID取得
data "aws_caller_identity" "self" { }

# アクセスポリシー設定
data "aws_iam_policy_document" "sqs_queue_policy" {
 statement {
    sid    = "__owner_statemen"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.self.account_id}"]
    }

    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.sqs_queue.arn]
  }

  statement {
    sid    = "__sender_statement"
    effect = "Allow"

    principals {
      type        = "AWS"
    #   identifiers = ["${data.aws_caller_identity.self.account_id}"]
      identifiers = [var.send_user_arn_or_account]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.sqs_queue.arn]
  }
    statement {
    sid    = "__receiver_statement"
    effect = "Allow"

    principals {
      type        = "AWS"
    #   identifiers = ["${data.aws_caller_identity.self.account_id}"]
      identifiers = [var.receiver_user_arn_or_account]
    }

    actions   = ["sqs:ChangeMessageVisibility",
                 "sqs:DeleteMessage",
                 "sqs:ReceiveMessage" ]
    resources = [aws_sqs_queue.sqs_queue.arn]
  }
}
# アクセスポリシーアタッチ
resource "aws_sqs_queue_policy" "policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_queue_policy.json
}

# {
#   "Id": "Policy1711003506951",
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "Stmt1711003277057",
#       "Action": [
#         "sqs:SendMessage"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:sqs:ap-northeast-1:556476093219:sqs-prd-biz-dlq-jp1link01.fifo",
#       "Principal": {
#         "AWS": [
#           "arn:aws:iam::556476093219:role/iamrl-prd-biz-lambda_jp1-01"
#         ]
#       }
#     },
#     {
#       "Sid": "Stmt1711003494485",
#       "Action": [
#         "sqs:ChangeMessageVisibility",
#         "sqs:DeleteMessage",
#         "sqs:ReceiveMessage"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:sqs:ap-northeast-1:556476093219:sqs-prd-biz-dlq-jp1link01.fifo",
#       "Principal": {
#         "AWS": [
#           "arn:aws:iam::556476093219:role/iamrl-prd-biz-sqs_link_aws-jp1"
#         ]
#       }
#     }
#   ]
# }

# キュー所有者のみ
# {
#   "Id": "Policy1711003657171",
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "Stmt1711003611230",
#       "Action": [
#         "sqs:SendMessage"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:sqs:ap-northeast-1:556476093219:sqs-prd-biz-dlq-jp1link01.fifo",
#       "Principal": {
#         "AWS": [
#           "556476093219"
#         ]
#       }
#     },
#     {
#       "Sid": "Stmt1711003654247",
#       "Action": [
#         "sqs:ChangeMessageVisibility",
#         "sqs:DeleteMessage",
#         "sqs:ReceiveMessage"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:sqs:ap-northeast-1:556476093219:sqs-prd-biz-dlq-jp1link01.fifo",
#       "Principal": {
#         "AWS": [
#           "556476093219"
#         ]
#       }
#     }
#   ]
# }
# arn:aws:iam::942014761786:root