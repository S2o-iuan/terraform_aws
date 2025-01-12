# NameタグからVPC情報を取得
data "aws_vpc" "self" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_lb" "self" {
  count    = var.tg_attachments != null ? 1 : 0
  name     = var.tg_attachments
}

resource "aws_lb_target_group" "this" {
  target_type      = var.tg_target_type
  name             = var.tg_name
  port             = var.tg_port
  protocol         = var.tg_protocol
  protocol_version = var.tg_protocol_version
  ip_address_type  = var.tg_ip_address_type

  vpc_id = data.aws_vpc.self.id

  health_check {
    protocol = var.tg_health_check_protocol
    path     = var.tg_health_check_path
    port     = var.tg_health_check_port

    #正常判断数
    healthy_threshold = var.tg_health_check_healthy
    #異常判断数
    unhealthy_threshold = var.tg_health_check_unhealth
    #応答時間制限（秒）
    timeout = var.tg_health_check_timeout
    #実行間隔（秒）
    interval = var.tg_health_check_interval

    # 基準レスポンス
    # nlb には不要
    matcher = var.tg_health_check_matcher

  }

  tags = {
    Name         = var.tg_name
    Account      = var.tg_account
    Environment  = var.tg_env
    ManagedBy    = var.tg_managedby
    map-migrated = var.tg_mapmigrated
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count            = var.tg_attachments != null ? 1 : 0
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = data.aws_lb.self[0].arn
  port             = var.tg_port
}


resource "aws_lb_target_group_attachment" "ip" {
  for_each          = var.tg_attachments_ip
  target_group_arn  = aws_lb_target_group.this.arn
  target_id         = each.value[0]
  availability_zone = each.value[1]
  port              = each.value[2]
}