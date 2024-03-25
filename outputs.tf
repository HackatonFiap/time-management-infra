# outputs.tf

output "alb_hostname_conta" {
  value = aws_alb.main.dns_name
}

output "dns_banco_rds" {
  value = aws_db_instance.db_instance.endpoint
}
