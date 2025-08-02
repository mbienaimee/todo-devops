# terraform/azure/outputs.tf

# Defines the outputs to get the dynamic URLs.
output "web_app_url" {
  description = "The URL of the deployed App Service for the current environment."
  value       = azurerm_linux_web_app.app_service.default_hostname
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.rg.name
}