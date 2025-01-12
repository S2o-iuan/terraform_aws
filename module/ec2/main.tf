#iam_instance_profile取得
data "aws_iam_instance_profile" "instance_profiles" {
  name = var.role_name
}
#kmsキー取得
data "aws_kms_alias" "kms_name" {
  name = var.ebs_volume_kms_name
}
#ami取得
data "aws_ami" "ami" {
  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}
#subnet取得
data "aws_subnet" "network_interface_1_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.network_interface_1_subnet_name}"]
  }
}
#sg取得
data "aws_security_groups" "security_groups" {
    filter {
    name   = "group-name"
    values = var.security_groups_names
  }
}
#eni#
resource "aws_network_interface" "network_interface_1" {
  subnet_id                     = data.aws_subnet.network_interface_1_subnet.id
  private_ips                   = var.network_interface_1_private_ips
  security_groups               = data.aws_security_groups.security_groups.ids
  tags = {            
    Name                        = var.network_interface_name
    Environment                 = var.Environment
    Account                     = var.Account
    ManagedBy                   = var.ManagedBy
  }
}

#ec2#
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  network_interface {
    network_interface_id = aws_network_interface.network_interface_1.id
    device_index         = 0
  }

  disable_api_termination       = var.ec2_instance_disable_api_termination #終了保護の有効化する
  iam_instance_profile          = data.aws_iam_instance_profile.instance_profiles.name
  ebs_optimized                 = var.ec2_instance_ebs_optimized #EBSの最適化
  monitoring                    = var.ec2_instance_monitoring #詳細モニタリングの有効化
  user_data                     = var.ec2_instance_user_data
  
  metadata_options {
    http_tokens                 = var.ec2_instance_http_tokens #メタデータのバージョンをV2にする
    http_put_response_hop_limit = var.ec2_instance_http_put_response_hop_limit #メタデータのポップ制限設定
  }

  root_block_device {
    delete_on_termination = var.root_volume_delete_on_termination #インスタンス終了時にボリュームを破棄しない
    kms_key_id            = data.aws_kms_alias.kms_name.target_key_arn
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    iops                  = var.root_volume_iops
    throughput            = var.root_volume_throughput
    encrypted             = var.root_volume_encrypted 
    tags = {
      Name          = var.root_volume_name
      Environment   = var.Environment
      Account       = var.Account
      ManagedBy     = var.ManagedBy
        }
    }
    tags = {
    Name          = var.ec2_instance_name
    Environment   = var.Environment
    Account       = var.Account
    ManagedBy     = var.ManagedBy
  }
}
