#sg取得
data "aws_security_groups" "security_groups" {
    filter {
    name   = "group-name"
    values = var.security_groups_names
  }
}
#subnet取得
data "aws_subnet" "network_interface_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.network_interface_subnet_name}"]
  }
}
resource "aws_network_interface" "network_interface" {
  subnet_id       = data.aws_subnet.network_interface_subnet.id
  private_ips     = var.eni_private_ips
  security_groups = data.aws_security_groups.security_groups.ids
  tags = {
    Name        = var.network_interface_name
    Environment = var.Environment
    Account     = var.Account
    ManagedBy   = var.ManagedBy
  }
  attachment {
       instance     = var.ec2_instance_id
       device_index = var.eni_device_index
  }
}