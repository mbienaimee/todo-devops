# main.tf: This file defines the core infrastructure resources for the project.

# Configure the Azure provider.
provider "azurerm" {
  features {}
}

# A resource group is a logical container for your Azure resources.
resource "azurerm_resource_group" "rg" {
  name     = "todo-devops-rg"
  location = "East US"
}

# The App Service Plan defines the underlying virtual machines for the web app.
resource "azurerm_service_plan" "app_plan" {
  name                = "todo-devops-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

# This is the web application itself, which will run inside the App Service Plan.
resource "azurerm_linux_web_app" "app_service" {
  name                = "todo-devops-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}
