# terraform/azure/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0" # This version is compatible with v4.37.0 you have
    }
  }
  required_version = ">= 1.3.0" # Keeps your Terraform CLI version compatibility

  # --- START OF REMOTE BACKEND CONFIGURATION ---
  backend "azurerm" {
    resource_group_name  = "todo-devops-rg" # Your existing resource group for infrastructure
    storage_account_name = "tdopsbienaimeetfstate" # <<< YOUR UNIQUE STORAGE ACCOUNT NAME!
    container_name       = "tfstate"        # This should be 'tfstate'
    key                  = "terraform.tfstate" # This is the name of your state file within the container
  }
  # --- END OF REMOTE BACKEND CONFIGURATION ---
}

# --- START OF PROVIDER CONFIGURATION ---
provider "azurerm" {
  features {}
  # Explicitly specify the subscription ID for the provider
  subscription_id = "736b4173-e1ed-46ae-be69-2241d0f855e8" # <<< YOUR ACTUAL AZURE SUBSCRIPTION ID!
}
# --- END OF PROVIDER CONFIGURATION ---


# --- START OF RESOURCE DEFINITIONS (APPLY NAMING CONVENTION) ---

# 1. Resource Group (still environment-specific for app isolation)
resource "azurerm_resource_group" "rg" {
  name     = "todo-devops-${var.environment}-rg"
  location = var.location
}

# 2. Log Analytics Workspace (for Container Apps Environment logging)
# This can also be shared, or kept per-environment if preferred.
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "todo-devops-log-workspace" # Generic name for shared workspace
  location            = var.location
  resource_group_name = "todo-devops-rg" # This should be in your main infra RG
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 3. Azure Container Apps Environment (SINGLE INSTANCE)
# This will be shared by both staging and production apps
resource "azurerm_container_app_environment" "aca_env" {
  name                       = "todo-devops-aca-env" # Generic name for shared environment
  resource_group_name        = "todo-devops-rg" # This should be in your main infra RG
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
}

# 4. Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "tdops${var.environment}registry" # Example: tdopsproductionregistry, tdopsstagingregistry
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic" # Or 'Standard', 'Premium'
  admin_enabled       = true    # Needed for ACR_USERNAME/PASSWORD secrets in pipeline
}

# 5. Azure Cosmos DB Account (for MongoDB API)
resource "azurerm_cosmosdb_account" "db_account" {
  name                = "tdops${var.environment}cosmosdb" # Example: tdopsproductioncosmosdb, tdopsstagingcosmosdb
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB" # Ensure this is "MongoDB" if you are using MongoDB API

  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  capabilities {
    name = "EnableMongo" # This capability is important for MongoDB API
  }
  # Add other properties as per your Assignment 2 configuration, e.g., network_acl, public_network_access_enabled
  # For example:
  # public_network_access_enabled = true
}

# 6. Backend Container App
resource "azurerm_container_app" "backend" {
  name                         = "todo-backend-app-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id # References the single shared environment
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single" # Or "Multiple" if you want to manage revisions

  template {
    container {
      name   = "backend-app"
      image  = "${azurerm_container_registry.acr.login_server}/${local.backend_image_name}" # Placeholder, pipeline will update tag
      cpu    = 0.5
      memory = "1.0Gi"
      env {
        name  = "COSMOSDB_CONNECTION_STRING"
        value = azurerm_cosmosdb_account.db_account.primary_mongodb_connection_string
      }
      # Add other container settings like ports, probes etc.
      # For example:
      # port {
      #   container_port = 3001
      #   transport      = "tcp"
      # }
    }
    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = true
    target_port      = 3001 # Your backend's port
    transport        = "auto"
    allow_insecure_connections = false
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

# 7. Frontend Container App
resource "azurerm_container_app" "frontend" {
  name                         = "todo-frontend-app-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id # References the single shared environment
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single" # Or "Multiple"

  template {
    container {
      name   = "frontend-app"
      image  = "${azurerm_container_registry.acr.login_server}/${local.frontend_image_name}" # Placeholder, pipeline will update tag
      cpu    = 0.5
      memory = "1.0Gi"
      env {
        name  = "REACT_APP_BACKEND_URL"
        value = azurerm_container_app.backend.ingress[0].fqdn # This links to the backend FQDN
      }
      # Add other container settings like ports, probes etc.
      # For example:
      # port {
      #   container_port = 80
      #   transport      = "tcp"
      # }
    }
    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = true
    target_port      = 80 # Your frontend's port
    transport        = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

# --- END OF RESOURCE DEFINITIONS ---


# --- START OF LOCAL VARIABLES (for image names) ---
# These are internal to the module and help keep resource definitions clean.
locals {
  backend_image_name = "mbienaimee/todo-backend" # Adjust if your image name is different (without registry prefix)
  frontend_image_name = "mbienaimee/todo-frontend" # Adjust if your image name is different (without registry prefix)
}
# --- END OF LOCAL VARIABLES ---
