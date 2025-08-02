# This file is for global Terraform configuration, such as the required version.
# The required_providers block is best kept in a separate file like providers.tf
# to avoid conflicts.
terraform {
  # The backend block is commented out because it's handled by your `terraform init` command.
  /*
  backend "azurerm" {
    resource_group_name  = "todo-devops-rg"
    storage_account_name = "tdopsbienaimeetfstate"
    container_name       = "tfstate"
    key                  = "staging.tfstate"
  }
  */
}
