# ------------------------------------
# File: main.tf
# Description: Defines the core Azure resources for a Container App
# ------------------------------------

# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# The provider block is where we add the features block to control provider behavior.
provider "azurerm" {
  features {
    resource_group {
      # This is the fix. It allows Terraform to destroy a resource group
      # even if it contains resources. This is necessary for the old resource group
      # to be cleaned up.
      prevent_deletion_if_contains_resources = false
    }
  }
}

# This is the backend that stores your Terraform state in a remote location.
# Replace the values with your own Azure storage account details.
backend "azurerm" {
  resource_group_name  = "todo-devops-rg"
  storage_account_name = "tdopsbienaimeetfstate"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}

# ------------------------------------
# Input Variables
# ------------------------------------

# This is the name of your new resource group
variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "todo-devops-rg"
}

# This is the Azure region where your resources will be deployed
variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "southafricanorth"
}

# ------------------------------------
# Azure Resources
# ------------------------------------

# Define a resource group to hold all our resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# This data block queries an existing Log Analytics Workspace by its name and resource group.
# This assumes the workspace is already created in your subscription.
# The name is constructed based on the resource group name for consistency.
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
