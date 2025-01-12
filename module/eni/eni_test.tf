locals {
  eni = {
    network_interface_name = ""
    Environment = ""
    Account = ""
    ManagedBy = ""
    network_interface_subnet_name = ""
    eni_private_ips = ""
    security_groups_names = ""
    eni_device_index = ""
  }
}

module "eni" {
  source = "../../module/eni/"

    ec2_instance_id = module.ec2.instance_id
    network_interface_name = local.eni.network_interface_name
    Environment = local.eni.network_interface_subnet_name
    Account = local.eni.Account
    ManagedBy = local.eni.ManagedBy
    network_interface_subnet_name = local.eni.network_interface_subnet_name
    eni_private_ips = local.eni.eni_private_ips
    security_groups_names = local.eni.security_groups_names
    eni_device_index = local.eni.eni_device_index
}
