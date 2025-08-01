# ------------------------------------
# File: main.tf
# Description: Defines the core Azure resources for a Container App
# ------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # The backend block MUST be nested inside the terraform block.
  backend "azurerm" {
    resource_group_name  = "todo-devops-rg"
    storage_account_name = "tdopsbienaimeetfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# The provider block is where we add the 'features' block to control provider behavior.
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# ------------------------------------
# Azure Resources
# ------------------------------------

# Define a resource group to hold all our resources.
# The name is now dynamically set based on the `environment` variable.
resource "azurerm_resource_group" "rg" {
  name     = "todo-devops-${var.environment}-rg"
  location = var.location
}

# Add the Azure Container Registry (ACR) resource.
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Look up an existing Log Analytics Workspace.
# This assumes the workspace is already created in your subscription.
data "azurerm_log_analytics_workspace" "la" {
  name                = "la-todo-devops-${var.environment}-rg"
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a Container App Environment. This is the foundation for your apps.
resource "azurerm_container_app_environment" "app_env" {
  name                       = "cae-todo-devops-${var.environment}-rg"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.la.id
}

# Define the actual Container App
resource "azurerm_container_app" "app" {
  name                         = "ca-todo-devops-${var.environment}-rg"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = azurerm_resource_group.rg.name

  # The revision_mode is a required argument for container apps.
  revision_mode = "Single"

  ingress {
    external_enabled = true
    target_port      = 80

    # A traffic_weight block is required when ingress is enabled.
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name   = "helloworld"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }
}
