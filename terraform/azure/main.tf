# terraform/azure/main.tf

# Defines the core infrastructure resources using the environment variable.
resource "azurerm_resource_group" "rg" {
  name     = "todo-devops-${var.environment}-rg"
  location = var.location
}

resource "azurerm_service_plan" "app_plan" {
  name                = "todo-devops-${var.environment}-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "todo-devops-app-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}
