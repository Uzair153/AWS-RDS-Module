provider "aws" {
  region = "us-east-1"
}

#-----------------------------------------------------------------------------------------------------------------

module "postgres-instance" {

  source                  = "./modules/postgres-instance"
  environment             = var.environment
  kms_key_arn             = var.kms_key_arn
  database_identifier     = var.database_identifier
  db_instance_class       = var.db_instance_class
  multi_az                = var.multi_az
  engine                  = var.engine
  project                 = var.project
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = var.storage_encrypted
  vpc_id                  = var.vpc_id
  aws_db_subnet_group     = var.aws_db_subnet_group
}

