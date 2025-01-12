# BCP-保険Web
locals {
  ec2 = {
    role_name                                = "role_name" #IAMインスタンスプロファイル
    network_interface_name                   = "eni-name"
    ec2_instance_name                        = "ec2-name"
    root_volume_name                         = "ebs-name"
    ebs_volume_kms_name                      = "alias/kms_key" #kmsキー記入　alisa/kmsキー
    Environment                              = "bcp"
    Account                                  = "biz"
    ManagedBy                                = "terraform"
    network_interface_1_subnet_name          = "subnet" #サブネット（サーバ用）
    network_interface_1_private_ips          = ["ip"]   #ネットワークインターフェース1　プライマリIP
    security_groups_names                    = ["sgp"] #ファイアウォール(セキュリティグループ)  
    ami_name                                 = "ami" #AMI名
    instance_type                            = "c6i.large"#インスタンスタイプ
    ec2_instance_disable_api_termination     = true       #終了保護の有効化する
    ec2_instance_ebs_optimized               = true       #EBSの最適化
    ec2_instance_monitoring                  = true       #詳細モニタリングの有効化
    ec2_instance_http_tokens                 = "required" #メタデータのバージョンをV2にする
    ec2_instance_http_put_response_hop_limit = "1"        #メタデータのポップ制限設定
    ec2_instance_user_data                   = <<EOF
#!/bin/bash
chage -M 99999 ansibleuser           
EOF
    #user_dataがない場合は  
    #ec2_instance_user_data                   = <<EOF             
    #  EOF
    root_volume_delete_on_termination        = false #インスタンス終了時にボリュームを破棄しない
    root_volume_encrypted                    = true
    root_volume_size                         = 40
    root_volume_type                         = "gp3"
    root_volume_iops                         = 3000
    root_volume_throughput                   = 125
  }
  ebs = {
    ebs_volume_name                 = "ebs-name"             #最後の数字は自動計算のため記入しない
    volume_size                     = [4, 6, 20, ]                           #root_volume以外のebs_volume [volume1個目size, 2個目size, ...., n個目size]
    volume_type                     = ["gp3", "gp3", "gp3", ]                #root_volume以外のebs_volume [volume1個目type, 2個目type, ...., n個目type]
    volume_iops                     = [3000, 3000, 3000, ]                   #root_volume以外のebs_volume [volume1個目iops, 2個目iops, ...., n個目iops]
    volume_throughput               = [125, 125, 125, ]                      #root_volume以外のebs_volume [volume1個目throughput, 2個目throughput, ...., n個目throughput]
    device_name                     = ["/dev/sdf", "/dev/sdg", "/dev/sdh", ] #root_volume以外のebs_volume [volume1個目device_name, 2個目device_name, ...., n個目device_name]
    Environment                     = "bcp"
    Account                         = "biz"
    ManagedBy                       = "terraform"
    volume_encrypted                = true
    ebs_volume_kms_name             = "alias/kms" #kmsキー記入　alisa/kmsキー
    network_interface_1_subnet_name = "subnet"   #サブネット（サーバ用）
  }
  #eniが2個の場合、下の内容を記入。1個の場合は全部不要
  # eni = {
  #   network_interface_name        = "eni-xxxxxxxxxxxxxx"
  #   Environment                   = "bcp"
  #   Account                       = "biz"
  #   ManagedBy                     = "terraform"
  #   network_interface_subnet_name = "xxxxxxxxxx" #サブネット（外接用）
  #   eni_private_ips               = ["xxxxxxxxxx"]  #ネットワークインターフェース2　プライマリIP
  #   security_groups_names         = ["xxxxxxxxxxx", "xxxxxxxxxxxxxx"] #ファイアウォール(セキュリティグループ)
  #   eni_device_index              = 1 
  # }
  #eniが2個の場合、上の内容を記入。1個の場合は全部不要
}

module "ec2" {
  source = "../../../module/ec2/"
  
  role_name                                = local.ec2.role_name
  network_interface_name                   = local.ec2.network_interface_name
  ec2_instance_name                        = local.ec2.ec2_instance_name
  ebs_volume_kms_name                      = local.ec2.ebs_volume_kms_name
  Environment                              = local.ec2.Environment
  Account                                  = local.ec2.Account
  ManagedBy                                = local.ec2.ManagedBy
  network_interface_1_subnet_name          = local.ec2.network_interface_1_subnet_name
  network_interface_1_private_ips          = local.ec2.network_interface_1_private_ips
  security_groups_names                    = local.ec2.security_groups_names
  ami_name                                 = local.ec2.ami_name
  instance_type                            = local.ec2.instance_type
  ec2_instance_disable_api_termination     = local.ec2.ec2_instance_disable_api_termination
  ec2_instance_ebs_optimized               = local.ec2.ec2_instance_ebs_optimized
  ec2_instance_monitoring                  = local.ec2.ec2_instance_monitoring
  ec2_instance_http_tokens                 = local.ec2.ec2_instance_http_tokens
  ec2_instance_http_put_response_hop_limit = local.ec2.ec2_instance_http_put_response_hop_limit
  ec2_instance_user_data                   = local.ec2.ec2_instance_user_data
  root_volume_delete_on_termination        = local.ec2.root_volume_delete_on_termination
  root_volume_encrypted                    = local.ec2.root_volume_encrypted
  root_volume_name                         = local.ec2.root_volume_name
  root_volume_size                         = local.ec2.root_volume_size
  root_volume_type                         = local.ec2.root_volume_type
  root_volume_iops                         = local.ec2.root_volume_iops
  root_volume_throughput                   = local.ec2.root_volume_throughput
}
module "ebs" {
  source = "../../../module/ebs/"
  
  ec2_instance_id                 = module.ec2.instance_id
  ebs_volume_name                 = local.ebs.ebs_volume_name
  volume_size                     = local.ebs.volume_size
  volume_type                     = local.ebs.volume_type
  volume_iops                     = local.ebs.volume_iops
  volume_throughput               = local.ebs.volume_throughput
  device_name                     = local.ebs.device_name
  Environment                     = local.ebs.Environment
  Account                         = local.ebs.Account
  ManagedBy                       = local.ebs.ManagedBy
  volume_encrypted                = local.ebs.volume_encrypted
  ebs_volume_kms_name             = local.ebs.ebs_volume_kms_name
  network_interface_1_subnet_name = local.ebs.network_interface_1_subnet_name
}
#eniが2個の場合、下の内容を記入。1個の場合は全部不要
# module "eni" {
#   source = "../../../module/eni/"
  
#   ec2_instance_id               = module.ec2.instance_id
#   network_interface_name        = local.eni.network_interface_name
#   Environment                   = local.eni.Environment
#   Account                       = local.eni.Account
#   ManagedBy                     = local.eni.ManagedBy
#   network_interface_subnet_name = local.eni.network_interface_subnet_name
#   eni_private_ips               = local.eni.eni_private_ips
#   security_groups_names         = local.eni.security_groups_names
#   eni_device_index              = local.eni.eni_device_index
# }