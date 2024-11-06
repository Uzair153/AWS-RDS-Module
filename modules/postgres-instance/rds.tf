#----------------------------------------------Fetch the latest version-------------------------------------------------------------

data "aws_rds_engine_version" "latest_postgres" {
  engine = "postgres"
}

#----------------------------------------Fetch Subnet IDs in the specified VPC-------------------------------------------------------

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = var.aws_db_subnet_group
  subnet_ids  = data.aws_subnets.example.ids
  description = "Subnet group for ${var.environment} RDS instance"
}

#----------------------------------------Fetch the Security Group IDs in the specified VPC-----------------------------------------

data "aws_security_group" "example" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

#----------------------------------------------------- RDS Instance------------------------------------------------------------------

resource "aws_db_instance" "postgres" {
  identifier              = local.cluster_name
  db_name                 = local.db_name
  engine                  = var.engine
  engine_version          = data.aws_rds_engine_version.latest_postgres.version
  skip_final_snapshot     = true
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  username                = "masterusername"
  password                = random_password.rds_master_password.result
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_arn
  parameter_group_name    = "default.postgres${split(".", data.aws_rds_engine_version.latest_postgres.version)[0]}"
  vpc_security_group_ids  = [data.aws_security_group.example.id]


  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = local.cluster_name
    }
  )
}

#-------------------------------------------------locals------------------------------------------------------------

locals {
  is_prod = var.environment == "prod" || var.environment == "demo"

  # Construct the database cluster name
  cluster_prefix = local.is_prod ? "ssawsaur" : "ssnprdaur"
  cluster_name   = "${local.cluster_prefix}-${var.database_identifier}-qorta"

  # Construct the initial database name
  db_name = "${var.database_identifier}qorta${var.environment}"

  # Define common tags
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    # Add other common tags as per your organization's policy
  }
}