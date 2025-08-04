# terraform/azure/providers.tf

# Configure the Azure provider.
# The subscription_id is now referenced from the variables.tf file.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Provider configuration for Azure.
# The subscription ID is passed from the variable defined in variables.tf.
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  
  # This flag prevents Terraform from trying to automatically register all resource providers,
  # which resolves the "Cannot register providers" error.
  skip_provider_registration = true
}