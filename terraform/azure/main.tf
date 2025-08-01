# main.tf: This file defines the core infrastructure resources for the project.

# Configure the Azure provider.
provider "azurerm" {
  features {}
}

# The main resource group for the project.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# An App Service Plan defines the underlying virtual machines for your App Services.
# The "B1" sku is a basic, cost-effective option for development.
resource "azurerm_service_plan" "app_plan" {
  name                = "${var.app_name}-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

# This is the web application itself, which will run inside the App Service Plan.
# It's configured to run a Node.js 18 LTS app.
resource "azurerm_linux_web_app" "app_service" {
  name                = "${var.app_name}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}
