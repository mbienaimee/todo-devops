# This file defines the required versions for Terraform and its providers.
# It ensures that you are using a compatible version of the Azure provider.
terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # The version constraint has been updated to accept any 4.x version,
      # which resolves the conflict you were seeing.
      version = "~> 4.0"
    }
  }

  # The backend block specifies where Terraform should store its state.
  # This section is commented out because it's configured directly in your `terraform init` command.
  /*
  backend "azurerm" {
    resource_group_name  = "todo-devops-rg"
    storage_account_name = "tdopsbienaimeetfstate"
    container_name       = "tfstate"
    key                  = "staging.tfstate"
  }
  */
}
