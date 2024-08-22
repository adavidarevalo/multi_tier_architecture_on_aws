variable "ingress_cidr_blocks" {
  description = "Cidr blocks allowed to access to the Host Bastion"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "key_pair_path" {
  type = string
}

variable "key_pair_name" {
  description = "Key Pair name"
  type        = string
}

variable "tags" {
  type = object({})
}

variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "subnet_id" {
  type = string
}