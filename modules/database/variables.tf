variable "vpc_cidr_block" {
  type = string
}

variable "tags" {
  type = object({})
}

variable "db_rds_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_instance_type" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_max_allocated_storage" {
  type = number
}

variable "db_name" {
  description = "AWS RDS DAtabase Name"
  type        = string
}

variable "db_instance_identifier" {
  description = "AWS RDS Instance Identifier"
  type        = string
}

variable "db_username" {
  description = "AWS RDS Database Username"
  type        = string
}

variable "db_password" {
  description = "AWS RDS Database Password"
  type        = string
}

variable "db_subnet_group_name" {
  type = string
}