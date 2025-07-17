# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "736b4173-e1ed-46ae-be69-2241d0f855e8"
}

# --- Resource Group ---
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# --- Azure Container Registry (ACR) ---
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic" # Basic, Standard, Premium
  admin_enabled       = true    # Enable admin user for easy login
}

# --- Database (Azure Cosmos DB for MongoDB API - good for Node.js) ---
# Replace with Azure Database for PostgreSQL/MySQL if preferred and adapt backend connection string
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmosdb_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

# --- Azure Container Apps Environment ---
# This is where your container apps will run
resource "azurerm_container_app_environment" "app_env" {
  name                       = var.aca_environment_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id # Required for ACA environment
}

# Log Analytics Workspace (required for Container Apps Environment)
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${var.resource_group_name}-logs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# --- Azure Container App for Backend ---
# We'll create the actual container app (backend and frontend) manually later
# This is just for demonstration if you wanted to include it in Terraform
/*
resource "azurerm_container_app" "backend_app" {
  name                         = "todo-backend-app"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = azurerm_resource_group.rg.name

  template {
    container {
      name  = "backend"
      image = "${azurerm_container_registry.acr.login_server}/${var.docker_username}/todo-backend:latest"
      cpu   = 0.5
      memory = "1.0Gi"
      env {
        name        = "COSMOSDB_CONNECTION_STRING" # Update this name if your backend uses a different env var
        secret_name = "cosmosdb-conn-string" # Link to a secret defined below
      }
      # Add other necessary env vars here for your backend, e.g., for frontend URL
    }
    # min_replicas = 1
    # max_replicas = 1
  }

  secret {
    name  = "cosmosdb-conn-string"
    value = azurerm_cosmosdb_account.cosmosdb.connection_strings[0].connection_string
  }

  ingress {
    external_enabled = true # Makes the app publicly accessible
    target_port      = 3001 # The port your Node.js backend listens on
    transport        = "Auto"
  }
}
*/