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

  backend "azurerm" {
    resource_group_name  = "todo-devops-rg"
    storage_account_name = "tdopsbienaimeetfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Add the Azure Container Registry (ACR) resource.
# This resource is required for storing your Docker images.
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true # Enable admin user for easy access
}

data "azurerm_log_analytics_workspace" "la" {
  name                = "la-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app_environment" "app_env" {
  name                       = "cae-${var.resource_group_name}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.la.id
}

resource "azurerm_container_app" "app" {
  name                         = "ca-${var.resource_group_name}"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = azurerm_resource_group.rg.name

  # FIX: The revision_mode is now a required argument.
  revision_mode = "Single"

  ingress {
    external_enabled = true
    target_port      = 80

    # FIX: A traffic_weight block is required when ingress is enabled.
    # This sends 100% of traffic to the latest revision.
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

# ------------------------------------
# Outputs
# ------------------------------------
# This block is now moved to outputs.tf
