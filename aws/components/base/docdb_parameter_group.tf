resource "aws_docdb_cluster_parameter_group" "base_db_parameters" {
  name = "${replace(local.resource_prefix,"_","-")}-db-parameters-50"
  family = "docdb5.0"
  description = "Parameter group for MongoDB in env: ${var.environment}"

  parameter {
    name = "tls"
    value = var.mongo_ssl_enabled ? "enabled" : "disabled"
  }

  # parameter {
  #   name = "audit_logs"
  #   value = var.docdb_audit_logs
  #   apply_method = "immediate"
  # }

  tags = merge(local.default_tags,{
    Name = "${replace(local.resource_prefix,"_","-")}-db-parameters-50"
  })
}