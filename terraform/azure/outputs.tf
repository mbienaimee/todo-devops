output "resource_group_name" {
  description = "The name of the created Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  description = "The login server for Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "The admin username for Azure Container Registry"
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "The admin password for Azure Container Registry"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "cosmosdb_connection_string" {
  description = "The connection string for Cosmos DB (MongoDB API)"
  value       = azurerm_cosmosdb_account.cosmosdb.primary_mongodb_connection_string # <-- CORRECTED LINE
  sensitive   = true
}

output "aca_environment_name" {
  description = "The name of the Azure Container Apps Environment"
  value       = azurerm_container_app_environment.app_env.name
}