locals {
  ebs ={
    ebs_volume_name = ""
    volume_size = ""
    volume_type = ""
    volume_iops = ""
    volume_throughput = ""
    device_name = ""
    Environment = ""
    Account = ""
    ManagedBy = ""
    volume_encrypted = ""
    ebs_volume_kms_name = ""
    network_interface_1_subnet_name = ""
  }
}

module "ebs" {
  source = "../../module/ebs/"

    ec2_instance_id = module.ec2.instance_id
    ebs_volume_name = local.ebs.ebs_volume_name
    volume_size = local.ebs.volume_size
    volume_type = local.ebs.volume_type
    volume_iops = local.ebs.volume_iops
    volume_throughput = local.ebs.volume_throughput
    device_name = local.ebs.device_name
    Environment = local.ebs.Environment
    Account = local.ebs.Account
    ManagedBy = local.ebs.ManagedBy
    volume_encrypted = local.ebs.volume_encrypted
    ebs_volume_kms_name = local.ebs.ebs_volume_kms_name
    network_interface_1_subnet_name = local.ebs.network_interface_1_subnet_name
}