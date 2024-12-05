terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.11.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "36d15e42-604e-4cf7-96be-20ba39980dbd"
  features {}
}

resource "random_integer" "rndinteger" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "azurerg" {
  name     = "${var.resource_group_name}-${random_integer.rndinteger.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asplan" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_resource_group.azurerg.location
  os_type             = "Linux"
  sku_name            = "F1"
}


resource "azurerm_linux_web_app" "alwama" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_service_plan.asplan.location
  service_plan_id     = azurerm_service_plan.asplan.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.azurerg.name
  location                     = azurerm_resource_group.azurerg.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login_username
  administrator_login_password = var.sql_administrator_login_password
}

resource "azurerm_mssql_database" "sqldb" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.alwama.id
  repo_url               = var.gitHub_repo_url
  branch                 = "main"
  use_manual_integration = true
}