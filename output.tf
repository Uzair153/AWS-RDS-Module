#------------------------Outputs---------------------

output "postgres_instance_endpoint" {
  value = module.postgres-instance.db_instance_endpoint
}

output "postgres_master_password_secret" {
  value = module.postgres-instance.db_master_password_secret
}

output "postgres_database_name" {
  value = module.postgres-instance.database_name
}
