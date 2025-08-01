# ------------------------------------
# File: main.tf
# Description: Defines the core Azure resources for a Container App
# ------------------------------------

# This block configures the Terraform providers and the backend.
# The 'backend' block MUST be nested inside the 'terraform' block.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # This is the backend that stores your Terraform state in a remote location.
  # Terraform state files are critical for keeping track of your infrastructure.
  backend "azurerm" {
    resource_group_name  = "todo-devops-rg"
    storage_account_name = "tdopsbienaimeetfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# The provider block is where we add the 'features' block to control provider behavior.
# This is the fix for your initial error, allowing resource groups to be deleted.
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

# Define a resource group to hold all our resources
resource "azurerm_resource_group" "rg" {
  # The values for these variables are defined in the `variables.tf` file
  # and will be passed in by your GitHub Actions workflow.
  name     = var.resource_group_name
  location = var.location
}

# This data block queries an existing Log Analytics Workspace by its name and resource group.
# This assumes the workspace is already created in your subscription.
data "azurerm_log_analytics_workspace" "la" {
  name                = "la-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a Container App Environment. This is the foundation for your apps.
resource "azurerm_container_app_environment" "app_env" {
  name                       = "cae-${var.resource_group_name}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.la.id
}

# Define the actual Container App
resource "azurerm_container_app" "app" {
  name                         = "ca-${var.resource_group_name}"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = azurerm_resource_group.rg.name

  # Enable ingress to expose the app to the internet
  ingress {
    external_enabled = true
    target_port      = 80
  }

  # Define the container image and settings
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

# Output the fully qualified domain name (FQDN) of the container app
output "container_app_fqdn" {
  description = "The FQDN of the deployed container app."
  value       = azurerm_container_app.app.ingress[0].fqdn
}
