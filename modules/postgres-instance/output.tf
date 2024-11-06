output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.postgres.endpoint
}

output "db_master_password_secret" {
  description = "The ARN of the master password secret in Secrets Manager"
  value       = aws_secretsmanager_secret.rds_master_password.arn
}
output "database_name" {
  value       = aws_db_instance.postgres.db_name
  description = "The name of the initial database"
}

