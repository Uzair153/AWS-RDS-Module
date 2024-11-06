# ----------------------------------Secrets Manager for storing DB credentials------------------------------------------------------

resource "aws_secretsmanager_secret" "rds_master_password" {
  name        = "${var.environment}-rds-master-password-"
  description = "Master password for RDS in ${var.environment} environment"
}
