provider "aws" {
  region = var.region
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "vpc-id" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.vpc-id.id
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc-id.id
  tags = {
    Name = "prisb-terraform-test"
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.vpc-id.id
  name   = "default"
}

module "db" {
  source = "git@git.vti.com.vn:vticloud/vti_cloud_iac.git//modules/terraform-aws-rds"

  identifier = var.db_identifier

  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_encrypted = var.db_storage_encrypted

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  vpc_security_group_ids = [data.aws_security_group.default.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  multi_az = var.db_multi_az

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  # DB subnet group
  # Use remote to get subnet id
  #subnet_ids = "${data.terraform_remote_state.vpc.database_subnet_ids}"
  
  #subnet_ids = data.aws_subnet_ids.all.ids
  subnet_ids = data.aws_subnet_ids.private.ids
  
  # DB parameter group
  family = var.db_family

  # DB option group
  major_engine_version = var.db_major_engine_version

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.db_final_snapshot_identifier

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
