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

resource "aws_lb" "this" {
  name = var.lb_name
  #ALB,NLBを明示的に選択
  load_balancer_type = var.lb_type
  #ALBを配置するサブネットを指定
  subnets = [for subnet in data.aws_subnets.self.ids : subnet]
  tags = {
    Name         = var.lb_name
    Account      = var.lb_account
    Environment  = var.lb_enviroment
    ManagedBy    = var.lb_managedby
    map-migrated = var.lb_map_migrated
  }

  # 削除保護有効化
  enable_deletion_protection = true
  # クロスゾーン負荷分散
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn

  for_each        = var.lb_defalt_listener

  # 基本系が固定レスポンスなので決め打ち
  default_action {
    type = "forward"
    target_group_arn = each.value[0]
  }
}

resource "aws_vpc_endpoint_service" "vpc_endpoint_service" {
  acceptance_required        = true
  gateway_load_balancer_arns = [aws_lb.this.arn]
  allowed_principals         = var.gwlbe_allowed_principals_1
  tags = {
    Name         = var.gwlbe_name
    Account      = var.lb_account
    Environment  = var.lb_enviroment
    ManagedBy    = var.lb_managedby
    map-migrated = var.lb_map_migrated
  }
  supported_ip_address_types = ["ipv4"]
}


resource "aws_vpc_endpoint_service_allowed_principal" "endpoint_service_allowed_principal" {
  count                     = var.gwlbe_allowed_principals_2 != null ? 1 : 0
  vpc_endpoint_service_id   = aws_vpc_endpoint_service.vpc_endpoint_service.id
  principal_arn             = var.gwlbe_allowed_principals_2[0]
}

resource "aws_vpc_endpoint_connection_accepter" "this" {
  for_each                = toset(var.aws_vpc_endpoint_id)
  vpc_endpoint_service_id = aws_vpc_endpoint_service.vpc_endpoint_service.id
  vpc_endpoint_id         = each.key
}