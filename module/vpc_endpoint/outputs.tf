output "dns_name" {
  value = aws_vpc_endpoint.vpc_interface_endpoint[0].dns_entry[0].dns_name
}
output "hosted_zone_id" {
  value = aws_vpc_endpoint.vpc_interface_endpoint[0].dns_entry[0].hosted_zone_id
}