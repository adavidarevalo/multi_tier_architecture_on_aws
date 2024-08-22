output "db_instance_domain" {
  value = module.rdsDb.db_instance_domain != null ? module.rdsDb.db_instance_domain : replace(module.rdsDb.db_instance_address, ":3306", "")
}

output "db_instance_username" {
  value = module.rdsDb.db_instance_username
}

output "db_instance_name" {
  value = module.rdsDb.db_instance_name
}