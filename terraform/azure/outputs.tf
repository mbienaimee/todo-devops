# outputs.tf: This file defines the outputs that are displayed after a successful 'terraform apply'.

output "app_service_url" {
  description = "The URL of the deployed App Service."
  value       = azurerm_linux_web_app.app_service.default_hostname
}
