# terraform/azure/outputs.tf

output "staging_resource_group_name" {
  value       = "todo-devops-staging-rg"
  description = "The name of the staging resource group"
}

output "production_resource_group_name" {
  value       = "todo-devops-production-rg"
  description = "The name of the production resource group"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server for the Azure Container Registry"
}
