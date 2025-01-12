data "aws_security_groups" "self" {
  filter {
    name   = "group-name"
    values = var.data_sg_name
  }
}

data "aws_subnets" "self" {
  filter {
    name   = "tag:Name"
    values = var.data_subnet_name_list
  }
}

data "aws_subnet" "self" {
  for_each = toset(data.aws_subnets.self.ids)
  id       = each.value
}

data "aws_acm_certificate" "default" {
  for_each = { for key, value in var.lb_defalt_listener : key => value[3] != null ? value[3] : null if value[3] != null}
  domain   = each.value
}


data "aws_acm_certificate" "certificate" {
  for_each = var.has_lb_lister_certificate ? var.lb_lister_certificate : {}
  domain   = each.value[1]
}

resource "aws_lb" "this" {
  name = var.lb_name
  #インターネットからのアクセスを許可(必要かわからない)
  internal = var.lb_internal
  #ALB,NLBを明示的に選択（今回はALB）
  load_balancer_type = var.lb_type
  #別途作成したセキュリティグループを指定
  security_groups = data.aws_security_groups.self.ids
  #ALBを配置するサブネットを指定
  subnets = [for subnet in data.aws_subnets.self.ids : subnet]

  tags = {
    Name         = var.lb_name
    Account      = var.lb_account
    Environment  = var.lb_enviroment
    ManagedBy    = var.lb_managedby
    map-migrated = var.lb_map_migrated
  }

  idle_timeout = var.lb_idle_timeout
  # 削除保護有効化
  enable_deletion_protection = true
  enable_http2               = false
  # クライアントポートの保持
  enable_xff_client_port     = var.enable_xff_client_port
  # ホストヘッダーを保持
  preserve_host_header       = true

  access_logs {
    enabled = true
    bucket  = "${var.lb_access_logs}"
  }

  connection_logs {
    enabled = "${var.lb_connection_logs_enabled}"
    bucket  = "${var.lb_connection_logs}"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn

  for_each        = var.lb_defalt_listener
  protocol        = each.value[0]
  port            = each.value[1]
  ssl_policy      = each.value[2]
  certificate_arn = each.value[3] != null ? data.aws_acm_certificate.default["${each.key}"].arn : null


  # 基本系が固定レスポンスなので決め打ち
  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = each.value[4]
      content_type = each.value[5]
      message_body = each.value[6]
    }
  }
}


resource "aws_lb_listener_rule" "forward" {
  for_each     = var.has_lb_lister_rules_forward ? var.lb_lister_rules_forward : {}
  listener_arn = aws_lb_listener.this["${each.value[0]}"].arn

  priority = each.value[1]

  action {
    type             = "forward"
    target_group_arn = each.value[2]
  }

  condition {
    path_pattern {
      values = each.value[3]
    }
  }
}

resource "aws_lb_listener_rule" "header" {
  for_each     = var.has_lb_lister_rules_header ? var.lb_lister_rules_header : {}
  listener_arn = aws_lb_listener.this["${each.value[0]}"].arn

  priority = each.value[1]

  action {
    type             = "forward"
    target_group_arn = each.value[2]
  }

  condition {
    host_header {
      values = each.value[3]
    }
  }
}

resource "aws_lb_listener_rule" "ip" {
  for_each     = var.has_lb_lister_rules_ip ? var.lb_lister_rules_ip : {}
  listener_arn = aws_lb_listener.this["${each.value[0]}"].arn

  priority = each.value[1]

  condition {
    source_ip {
      values = each.value[2]
    }
  }

  action {
    type = "fixed-response"

    fixed_response {
      status_code  = each.value[3]
      content_type = each.value[4]
      message_body = each.value[5]
    }
  }
}


resource "aws_lb_listener_certificate" "certificate" {
  for_each        = var.has_lb_lister_certificate ? var.lb_lister_certificate : {}
  listener_arn    = aws_lb_listener.this["${each.value[0]}"].arn
  certificate_arn = data.aws_acm_certificate.certificate["${each.key}"].arn
}