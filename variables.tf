variable "resource_group_name" {
  description = "RG name"
  type        = string
}

variable "resource_group_location" {
  description = "RG Resource_group_location"
  type        = string
}

variable "app_service_plan_name" {
  description = "App service plan name"
  type        = string
}

variable "app_service_name" {
  description = "App service name"
  type        = string
}

variable "sql_server_name" {
  description = "SQL server name"
  type        = string
}

variable "sql_database_name" {
  description = "SQL database name"
  type        = string
}

variable "sql_administrator_login_username" {
  description = "SQL username"
  type        = string
}

variable "sql_administrator_login_password" {
  description = "SQL administrator login password"
  type        = string
}

variable "firewall_rule_name" {
  description = "Firewall rule name"
  type        = string
}

variable "gitHub_repo_url" {
  description = "GitHub repo URL"
  type        = string
}