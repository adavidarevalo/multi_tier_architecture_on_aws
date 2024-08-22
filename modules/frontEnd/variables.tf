variable "domain_name" {
  description = "Domain Name"
  type        = string
}

variable "name" {
  type = string
}

variable "tags" {
  type = object({})
}

variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "ec2_intance_type" {
  type = string
}

variable "key_pair_name" {
  description = "Key Pair name"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "monitoring_bucket_id" {
  type = string
}