variable "name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "ec2_intance_type" {
  type = string
}

variable "db_instance_domain" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_instance_username" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "tags" {
  type = object({})
}

variable "key_pair_name" {
  description = "Key Pair name"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "monitoring_bucket_id" {
  type = string
}