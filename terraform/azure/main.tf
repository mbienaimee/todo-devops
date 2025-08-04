# This Terraform configuration manages the Azure infrastructure for the ToDo application.
# It includes a resource group, a service plan, and a Linux web app.

# -----------------------------------------------------------------------------
# Define Azure Provider and Backend
# -----------------------------------------------------------------------------

# Configure the AzureRM Provider to manage Azure resources.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Define the backend to store the Terraform state file in Azure Storage.
  # This is crucial for collaborative and CI/CD environments.
  backend "azurerm" {
    resource_group_name  = "azurerm-tfstate-rg"
    storage_account_name = "azurermtfstate12345678"
    container_name       = "tfstate"
  }
}

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

# Define variables for customization and environment-specific settings.
variable "environment" {
  type        = string
  description = "The deployment environment (e.g., staging or production)."
}

variable "azure_subscription_id" {
  type        = string
  description = "The Azure subscription ID where resources will be deployed."
}

# -----------------------------------------------------------------------------
# Resources
# -----------------------------------------------------------------------------

# Create a resource group to contain all the application's resources.
# The name is dynamically generated based on the environment.
resource "azurerm_resource_group" "rg" {
  name     = "todo-devops-${var.environment}-rg"
  location = "East US"
}

# Create a service plan (App Service Plan) to host the web app.
# The `azurerm_service_plan` resource is the container for web apps.
resource "azurerm_service_plan" "app_plan" {
  name                = "todo-devops-${var.environment}-app-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1" # B1 is a Basic tier SKU, suitable for dev/test.
}

# Create a Linux web app to run the Docker container.
# This is the core application host.
resource "azurerm_linux_web_app" "web_app" {
  name                = "todo-devops-app-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.app_plan.location
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    # Specify the Docker image and registry details.
    always_on = true
  }

  app_settings = {
    # Pass the backend API URL to the frontend as an environment variable.
    VUE_APP_API_URL = "https://todo-devops-backend-${var.environment}.azurewebsites.net/api/todos"
  }
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

# Export the name of the production resource group for use in the workflow.
output "production_resource_group_name" {
  value = azurerm_resource_group.rg.name
}

# Export the name of the staging resource group for use in the workflow.
output "staging_resource_group_name" {
  value = azurerm_resource_group.rg.name
}
