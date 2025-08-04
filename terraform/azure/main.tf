# main.tf

# This resource creates a resource group to hold all the other resources.
resource "azurerm_resource_group" "rg" {
  name     = "todo-devops-${var.environment}-rg"
  location = var.location
}

# We use a data source to reference the existing Container App Environment
# to avoid the regional quota error from the previous attempt.
data "azurerm_container_app_environment" "existing" {
  name                = "todo-devops-aca-env"
  resource_group_name = "todo-devops-rg" # The existing environment is in this resource group.
}

# This resource defines the front-end container app.
resource "azurerm_container_app" "todo_frontend_app" {
  name                         = "todo-frontend-app-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = data.azurerm_container_app_environment.existing.id
  
  # Set the revision mode to Single, as this is the simplest configuration.
  revision_mode = "Single"

  template {
    container {
      name  = "todo-frontend"
      image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu   = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    
    # This block is required and directs all traffic to the latest active revision.
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
