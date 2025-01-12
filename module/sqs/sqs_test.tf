locals {
  sqs = {
    sqs_name                            = "0423_sqs_import_test.fifo"
    visibility_timeout_seconds          = "30"
    delay_seconds                       = "0"
    max_message_size                    = "262144"
    message_retention_seconds           = "345600"
    receive_wait_time_seconds           = "0"
    fifo_queue                          = true
    content_based_deduplication         = false
    deduplication_scope                 = "messageGroup"
    fifo_throughput_limit               = "perMessageGroupId"
    sqs_managed_sse_enabled             = true
    redrive_allow_policy                = false
    redrive_allow_policy_permission     = null
    redrive_allow_policy_queue_arn      = null
    dead_letter_queue                   = false
    dead_letter_queue_arn               = null
    dead_letter_queue_max_receive_count = null
    send_user_arn_or_account            = "942014761786"
    receiver_user_arn_or_account        = "942014761786"
  }
    sqs02 = {
      sqs_name                            = "sqs-baku-jp1link01.fifo"
      visibility_timeout_seconds          = "60"
      delay_seconds                       = "0"
      max_message_size                    = "262144"
      message_retention_seconds           = "345600"
      receive_wait_time_seconds           = "0"
      fifo_queue                          = true
      content_based_deduplication         = false
      deduplication_scope                 = "messageGroup"
      fifo_throughput_limit               = "perMessageGroupId"
      sqs_managed_sse_enabled             = true
      redrive_allow_policy                = false
      redrive_allow_policy_permission     = null
      redrive_allow_policy_queue_arn      = null
      dead_letter_queue                   = true
      dead_letter_queue_arn               = "arn:aws:sqs:ap-northeast-1:942014761786:0423_sqs_import_test.fifo"
      dead_letter_queue_max_receive_count = 2
      send_user_arn_or_account            = null
      receiver_user_arn_or_account        = null
      basic_policy                        = false
      advance_policy                      = true
      sqs_advance_policy                  = file("./iampl-itbst-biz0-s3_get_ptlogs01.json")
    }

  # #   sqs03 = {
  # #     sqs_name                            = "sqs_module_test03_baku.fifo"
  # #     visibility_timeout_seconds          = "30"
  # #     delay_seconds                       = "0"
  # #     max_message_size                    = "262144"
  # #     message_retention_seconds           = "345600"
  # #     receive_wait_time_seconds           = "0"
  # #     fifo_queue                          = true
  # #     content_based_deduplication         = false
  # #     deduplication_scope                 = "messageGroup"
  # #     fifo_throughput_limit               = "perMessageGroupId"
  # #     sqs_managed_sse_enabled             = true
  # #     redrive_allow_policy                = true
  # #     redrive_allow_policy_permission     = "byQueue"
  # #     redrive_allow_policy_queue_arn      = "arn:aws:sqs:ap-northeast-1:942014761786:sqs_module_test04_baku.fifo"
  # #     dead_letter_queue                   = false
  # #     dead_letter_queue_arn               = null
  # #     dead_letter_queue_max_receive_count = null
  # #     send_user_arn_or_account            = "942014761786"
  # #     receiver_user_arn_or_account        = "942014761786"
  # #   }
  # #   sqs04 = {
  # #     sqs_name                            = "sqs_module_test04_baku.fifo"
  # #     visibility_timeout_seconds          = "30"
  # #     delay_seconds                       = "0"
  # #     max_message_size                    = "262144"
  # #     message_retention_seconds           = "345600"
  # #     receive_wait_time_seconds           = "0"
  # #     fifo_queue                          = true
  # #     content_based_deduplication         = false
  # #     deduplication_scope                 = "messageGroup"
  # #     fifo_throughput_limit               = "perMessageGroupId"
  # #     sqs_managed_sse_enabled             = true
  # #     redrive_allow_policy                = false
  # #     redrive_allow_policy_permission     = null
  # #     redrive_allow_policy_queue_arn      = null
  # #     dead_letter_queue                   = true
  # #     dead_letter_queue_arn               = "arn:aws:sqs:ap-northeast-1:942014761786:sqs_module_test03_baku.fifo"
  # #     dead_letter_queue_max_receive_count = 5
  # #     send_user_arn_or_account            = "arn:aws:iam::942014761786:role/service-role/20200727_Lambda_test-role-qyu5b9km"
  # #     receiver_user_arn_or_account        = "arn:aws:iam::942014761786:role/service-role/parallel-put-sqs-test-role-cfyqu6k3"
  # #   }
  # #   sqs003 = {
  # #     sqs_name                            = "sqs_module_test004_baku.fifo"
  # #     visibility_timeout_seconds          = "30"
  # #     delay_seconds                       = "0"
  # #     max_message_size                    = "262144"
  # #     message_retention_seconds           = "345600"
  # #     receive_wait_time_seconds           = "0"
  # #     fifo_queue                          = true
  # #     content_based_deduplication         = false
  # #     deduplication_scope                 = "messageGroup"
  # #     fifo_throughput_limit               = "perMessageGroupId"
  # #     sqs_managed_sse_enabled             = true
  # #     redrive_allow_policy                = false
  # #     redrive_allow_policy_permission     = null
  # #     redrive_allow_policy_queue_arn      = null
  # #     dead_letter_queue                   = true
  # #     dead_letter_queue_arn               = "arn:aws:sqs:ap-northeast-1:942014761786:sqs_module_test003_baku.fifo"
  # #     dead_letter_queue_max_receive_count = 5
  # #     send_user_arn_or_account            = "arn:aws:iam::942014761786:role/service-role/20200727_Lambda_test-role-qyu5b9km"
  # #     receiver_user_arn_or_account        = "arn:aws:iam::942014761786:role/service-role/parallel-put-sqs-test-role-cfyqu6k3"
  # #   }
  # #   sqs004 = {
  # #     sqs_name                            = "sqs_module_test003_baku.fifo"
  # #     visibility_timeout_seconds          = "30"
  # #     delay_seconds                       = "0"
  # #     max_message_size                    = "262144"
  # #     message_retention_seconds           = "345600"
  # #     receive_wait_time_seconds           = "0"
  # #     fifo_queue                          = true
  # #     content_based_deduplication         = false
  # #     deduplication_scope                 = "messageGroup"
  # #     fifo_throughput_limit               = "perMessageGroupId"
  # #     sqs_managed_sse_enabled             = true
  # #     redrive_allow_policy                = true
  # #     redrive_allow_policy_permission     = "byQueue"
  # #     redrive_allow_policy_queue_arn      = "arn:aws:sqs:ap-northeast-1:942014761786:sqs_module_test004_baku.fifo"
  # #     dead_letter_queue                   = false
  # #     dead_letter_queue_arn               = null
  # #     dead_letter_queue_max_receive_count = null
  # #     send_user_arn_or_account            = "942014761786"
  # #     receiver_user_arn_or_account        = "942014761786"
  # #   }
}

module "sqs" {
  source = "./module/sqs/"

  sqs_name                            = local.sqs.sqs_name
  visibility_timeout_seconds          = local.sqs.visibility_timeout_seconds
  delay_seconds                       = local.sqs.delay_seconds
  max_message_size                    = local.sqs.max_message_size
  message_retention_seconds           = local.sqs.message_retention_seconds
  receive_wait_time_seconds           = local.sqs.receive_wait_time_seconds
  fifo_queue                          = local.sqs.fifo_queue
  content_based_deduplication         = local.sqs.content_based_deduplication
  deduplication_scope                 = local.sqs.deduplication_scope
  fifo_throughput_limit               = local.sqs.fifo_throughput_limit
  sqs_managed_sse_enabled             = local.sqs.sqs_managed_sse_enabled
  redrive_allow_policy                = local.sqs.redrive_allow_policy
  redrive_allow_policy_permission     = local.sqs.redrive_allow_policy_permission
  redrive_allow_policy_queue_arn      = local.sqs.redrive_allow_policy_queue_arn
  dead_letter_queue                   = local.sqs.dead_letter_queue
  dead_letter_queue_arn               = local.sqs.dead_letter_queue_arn
  dead_letter_queue_max_receive_count = local.sqs.dead_letter_queue_max_receive_count
  send_user_arn_or_account            = local.sqs.send_user_arn_or_account
  receiver_user_arn_or_account        = local.sqs.receiver_user_arn_or_account
}
module "sqs02" {
  source = "./module/sqs/"

  sqs_name                            = local.sqs02.sqs_name
  visibility_timeout_seconds          = local.sqs02.visibility_timeout_seconds
  delay_seconds                       = local.sqs02.delay_seconds
  max_message_size                    = local.sqs02.max_message_size
  message_retention_seconds           = local.sqs02.message_retention_seconds
  receive_wait_time_seconds           = local.sqs02.receive_wait_time_seconds
  fifo_queue                          = local.sqs02.fifo_queue
  content_based_deduplication         = local.sqs02.content_based_deduplication
  deduplication_scope                 = local.sqs02.deduplication_scope
  fifo_throughput_limit               = local.sqs02.fifo_throughput_limit
  sqs_managed_sse_enabled             = local.sqs02.sqs_managed_sse_enabled
  redrive_allow_policy                = local.sqs02.redrive_allow_policy
  redrive_allow_policy_permission     = local.sqs02.redrive_allow_policy_permission
  redrive_allow_policy_queue_arn      = local.sqs02.redrive_allow_policy_queue_arn
  dead_letter_queue                   = local.sqs02.dead_letter_queue
  dead_letter_queue_arn               = local.sqs02.dead_letter_queue_arn
  dead_letter_queue_max_receive_count = local.sqs02.dead_letter_queue_max_receive_count
  send_user_arn_or_account            = local.sqs02.send_user_arn_or_account
  receiver_user_arn_or_account        = local.sqs02.receiver_user_arn_or_account
  basic_policy                        = local.sqs02.basic_policy
  advance_policy                      = local.sqs02.advance_policy
  sqs_advance_policy                  = local.sqs02.sqs_advance_policy
}
# # module "sqs03" {
# #   source = "./module/sqs/"

# #   sqs_name                            = local.sqs03.sqs_name
# #   visibility_timeout_seconds          = local.sqs03.visibility_timeout_seconds
# #   delay_seconds                       = local.sqs03.delay_seconds
# #   max_message_size                    = local.sqs03.max_message_size
# #   message_retention_seconds           = local.sqs03.message_retention_seconds
# #   receive_wait_time_seconds           = local.sqs03.receive_wait_time_seconds
# #   fifo_queue                          = local.sqs03.fifo_queue
# #   content_based_deduplication         = local.sqs03.content_based_deduplication
# #   deduplication_scope                 = local.sqs03.deduplication_scope
# #   fifo_throughput_limit               = local.sqs03.fifo_throughput_limit
# #   sqs_managed_sse_enabled             = local.sqs03.sqs_managed_sse_enabled
# #   redrive_allow_policy                = local.sqs03.redrive_allow_policy
# #   redrive_allow_policy_permission     = local.sqs03.redrive_allow_policy_permission
# #   redrive_allow_policy_queue_arn      = local.sqs03.redrive_allow_policy_queue_arn
# #   dead_letter_queue                   = local.sqs03.dead_letter_queue
# #   dead_letter_queue_arn               = local.sqs03.dead_letter_queue_arn
# #   dead_letter_queue_max_receive_count = local.sqs03.dead_letter_queue_max_receive_count
# #   send_user_arn_or_account            = local.sqs03.send_user_arn_or_account
# #   receiver_user_arn_or_account        = local.sqs03.receiver_user_arn_or_account
# # }
# # module "sqs04" {
# #   source = "./module/sqs/"

# #   sqs_name                            = local.sqs04.sqs_name
# #   visibility_timeout_seconds          = local.sqs04.visibility_timeout_seconds
# #   delay_seconds                       = local.sqs04.delay_seconds
# #   max_message_size                    = local.sqs04.max_message_size
# #   message_retention_seconds           = local.sqs04.message_retention_seconds
# #   receive_wait_time_seconds           = local.sqs04.receive_wait_time_seconds
# #   fifo_queue                          = local.sqs04.fifo_queue
# #   content_based_deduplication         = local.sqs04.content_based_deduplication
# #   deduplication_scope                 = local.sqs04.deduplication_scope
# #   fifo_throughput_limit               = local.sqs04.fifo_throughput_limit
# #   sqs_managed_sse_enabled             = local.sqs04.sqs_managed_sse_enabled
# #   redrive_allow_policy                = local.sqs04.redrive_allow_policy
# #   redrive_allow_policy_permission     = local.sqs04.redrive_allow_policy_permission
# #   redrive_allow_policy_queue_arn      = local.sqs04.redrive_allow_policy_queue_arn
# #   dead_letter_queue                   = local.sqs04.dead_letter_queue
# #   dead_letter_queue_arn               = local.sqs04.dead_letter_queue_arn
# #   dead_letter_queue_max_receive_count = local.sqs04.dead_letter_queue_max_receive_count
# #   send_user_arn_or_account            = local.sqs04.send_user_arn_or_account
# #   receiver_user_arn_or_account        = local.sqs04.receiver_user_arn_or_account
# # }
# # module "sqs003" {
# #   source = "./module/sqs/"

# #   sqs_name                            = local.sqs003.sqs_name
# #   visibility_timeout_seconds          = local.sqs003.visibility_timeout_seconds
# #   delay_seconds                       = local.sqs003.delay_seconds
# #   max_message_size                    = local.sqs003.max_message_size
# #   message_retention_seconds           = local.sqs003.message_retention_seconds
# #   receive_wait_time_seconds           = local.sqs003.receive_wait_time_seconds
# #   fifo_queue                          = local.sqs003.fifo_queue
# #   content_based_deduplication         = local.sqs003.content_based_deduplication
# #   deduplication_scope                 = local.sqs003.deduplication_scope
# #   fifo_throughput_limit               = local.sqs003.fifo_throughput_limit
# #   sqs_managed_sse_enabled             = local.sqs003.sqs_managed_sse_enabled
# #   redrive_allow_policy                = local.sqs003.redrive_allow_policy
# #   redrive_allow_policy_permission     = local.sqs003.redrive_allow_policy_permission
# #   redrive_allow_policy_queue_arn      = local.sqs003.redrive_allow_policy_queue_arn
# #   dead_letter_queue                   = local.sqs003.dead_letter_queue
# #   dead_letter_queue_arn               = local.sqs003.dead_letter_queue_arn
# #   dead_letter_queue_max_receive_count = local.sqs003.dead_letter_queue_max_receive_count
# #   send_user_arn_or_account            = local.sqs003.send_user_arn_or_account
# #   receiver_user_arn_or_account        = local.sqs003.receiver_user_arn_or_account
# # }
# # module "sqs004" {
# #   source = "./module/sqs/"
# #   providers = {
# #     aws = aws.tokyo
# #   }

# #   sqs_name                            = local.sqs004.sqs_name
# #   visibility_timeout_seconds          = local.sqs004.visibility_timeout_seconds
# #   delay_seconds                       = local.sqs004.delay_seconds
# #   max_message_size                    = local.sqs004.max_message_size
# #   message_retention_seconds           = local.sqs004.message_retention_seconds
# #   receive_wait_time_seconds           = local.sqs004.receive_wait_time_seconds
# #   fifo_queue                          = local.sqs004.fifo_queue
# #   content_based_deduplication         = local.sqs004.content_based_deduplication
# #   deduplication_scope                 = local.sqs004.deduplication_scope
# #   fifo_throughput_limit               = local.sqs004.fifo_throughput_limit
# #   sqs_managed_sse_enabled             = local.sqs004.sqs_managed_sse_enabled
# #   redrive_allow_policy                = local.sqs004.redrive_allow_policy
# #   redrive_allow_policy_permission     = local.sqs004.redrive_allow_policy_permission
# #   redrive_allow_policy_queue_arn      = local.sqs004.redrive_allow_policy_queue_arn
# #   dead_letter_queue                   = local.sqs004.dead_letter_queue
# #   dead_letter_queue_arn               = local.sqs004.dead_letter_queue_arn
# #   dead_letter_queue_max_receive_count = local.sqs004.dead_letter_queue_max_receive_count
# #   send_user_arn_or_account            = local.sqs004.send_user_arn_or_account
# #   receiver_user_arn_or_account        = local.sqs004.receiver_user_arn_or_account
# # }