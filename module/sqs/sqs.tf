# sqs構築
resource "aws_sqs_queue" "sqs_queue" {
  name                        = var.sqs_name
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  delay_seconds               = var.delay_seconds
  max_message_size            = var.max_message_size 
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  fifo_throughput_limit       = var.fifo_throughput_limit
  sqs_managed_sse_enabled     = var.sqs_managed_sse_enabled

  tags = {
    Name = var.sqs_name
  }
}

# 許可ポリシーの再実行設定
resource "aws_sqs_queue_redrive_allow_policy" "redrive_allow_policy" {
  count = var.redrive_allow_policy == true ? 1 : 0
  queue_url = aws_sqs_queue.sqs_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "${var.redrive_allow_policy_permission}",
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

# ベーシックアクセスポリシー設定
data "aws_iam_policy_document" "sqs_queue_policy" {
 statement {
    sid    = "__owner_statement"
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
      identifiers = [var.receiver_user_arn_or_account]
    }

    actions   = ["sqs:ChangeMessageVisibility",
                 "sqs:DeleteMessage",
                 "sqs:ReceiveMessage" ]
    resources = [aws_sqs_queue.sqs_queue.arn]
  }
}
# ベーシックアクセスポリシーアタッチ
resource "aws_sqs_queue_policy" "policy" {
  count     = var.basic_policy == true ? 1 : 0
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_queue_policy.json
}

# アドバンストアクセスポリシーアタッチ
resource "aws_sqs_queue_policy" "advance_policy" {
  count     = var.advance_policy == true ? 1 : 0
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = var.sqs_advance_policy
}
