# ------------------------------------
# File: outputs.tf
# Description: Defines the outputs for the Terraform configuration.
# ------------------------------------

output "container_app_fqdn" {
  description = "The FQDN of the deployed container app."
  value       = azurerm_container_app.app.ingress[0].fqdn
}

# This output now works because the azurerm_container_registry resource
# is defined in main.tf.
output "acr_login_server" {
  description = "The login server for the Azure Container Registry."
  value       = azurerm_container_registry.acr.login_server
}
