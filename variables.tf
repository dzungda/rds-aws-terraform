#variable "env" {
#  default = "prd"
#}
#
#variable "account" {
#  default = "account"
#}
#
#variable "aws_profile" {
#  default = "aws_profile"
#}
#
#variable "account_ids" {
#  type = "map"
#
#  default = {}
#}

variable "region" {
}

variable "vpc_id" {
}

variable "db_identifier" {
}

variable "db_engine" {
}

variable "db_engine_version" {
}

variable "db_instance_class" {
}

variable "db_allocated_storage" {
}

variable "db_storage_encrypted" {
}

variable "db_name" {
}

variable "db_username" {
}

variable "db_port" {
  default = 3306
}

variable "db_password" {
}

variable "db_multi_az" {
}

variable "db_family" {
}

variable "db_major_engine_version" {
}

variable "db_final_snapshot_identifier" {
}

