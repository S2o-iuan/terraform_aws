#kmsキー取得
data "aws_kms_alias" "kms_name" {
  name = var.ebs_volume_kms_name
}
#subnet取得
data "aws_subnet" "network_interface_1_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.network_interface_1_subnet_name}"]
  }
}
#ebs#
resource "aws_ebs_volume" "ebs" {
 count             = length(var.volume_size)
 availability_zone = data.aws_subnet.network_interface_1_subnet.availability_zone
 kms_key_id        = data.aws_kms_alias.kms_name.target_key_arn
 size              = var.volume_size[count.index]
 type              = var.volume_type[count.index]
 iops              = var.volume_iops[count.index]
 throughput        = var.volume_throughput[count.index]
 encrypted         = var.volume_encrypted
 tags = {
      Name          = "${var.ebs_volume_name}-${count.index+1}"
      Environment   = var.Environment
      Account       = var.Account
      ManagedBy     = var.ManagedBy
 }
}
resource "aws_volume_attachment" "ebs" {
 count       = length(aws_ebs_volume.ebs[*].id)
 device_name = var.device_name[count.index]
 volume_id   = aws_ebs_volume.ebs[count.index].id
 instance_id = var.ec2_instance_id
}