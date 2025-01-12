resource "aws_acm_certificate" "certificate" {
  certificate_body  = var.certificate_body 
  certificate_chain = var.certificate_chain
  private_key       = var.private_key    
  tags = {
    Name         = var.acm_name
    Environment  = var.acm_environment
    Account      = var.acm_account
    ManagedBy    = var.acm_managedby
    map-migrated = var.acm_mapmigrated
  }
}