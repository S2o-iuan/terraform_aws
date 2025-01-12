data "aws_security_groups" "self" {
  filter {
    name   = "group-name"
    values = var.data_sg_name
  }
}

data "aws_subnet" "mapping1" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_mapping1]
  }
}

data "aws_subnet" "mapping2" {
  count    = var.subnet_mapping2 != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.subnet_mapping2]
  }
}

data "aws_eip" "eip1" {
  count    = var.eip_mapping1 != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.eip_mapping1]
  }
}

data "aws_eip" "eip2" {
  count    = var.eip_mapping2 != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.eip_mapping2]
  }
}

resource "aws_lb" "this" {
  name = var.lb_name
  #インターネットからのアクセスを許可(必要かわからない)
  internal = var.lb_internal
  #ALB,NLBを明示的に選択
  load_balancer_type = var.lb_type
  #別途作成したセキュリティグループを指定
  security_groups = data.aws_security_groups.self.ids
  subnet_mapping {
    subnet_id     = data.aws_subnet.mapping1
    allocation_id = var.eip_mapping1 != null ? data.aws_eip.eip1[0].id : null
  }
  subnet_mapping {
    subnet_id     = var.subnet_mapping2 != null ? data.aws_subnet.mapping2[0].id : null
    allocation_id = var.eip_mapping2 != null ? data.aws_eip.eip2[0].id : null
  }
  tags = {
    Name          = var.lb_name
    Account       = var.lb_account
    Environment   = var.lb_enviroment
    ManagedBy     = var.lb_managedby
    map-migrated  = var.lb_map_migrated
  }

  idle_timeout = var.lb_idle_timeout
  # 削除保護有効化
  enable_deletion_protection = true
  # クライアントルーティングポリシー
  dns_record_client_routing_policy = var.lb_dns_record_client_routing_policy

  access_logs {
    enabled = "${var.lb_access_logs_enabled}"
    bucket  = "${var.lb_access_logs}"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn

  for_each  = var.lb_defalt_listener
  protocol  = each.value[0]
  port      = each.value[1]


  # 基本系が固定レスポンスなので決め打ち
  default_action {
    type    = "forward"
    target_group_arn = each.value[2]
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
