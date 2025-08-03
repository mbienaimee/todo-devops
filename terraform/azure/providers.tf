# This file defines the providers and their versions.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# The rest of your provider configuration goes here
# This provider block now explicitly uses a variable for the subscription ID.
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

# Define the variable that will hold your Azure subscription ID.
# This variable is referenced in the provider block above.
variable "azure_subscription_id" {
  type        = string
  description = "The Azure subscription ID to deploy to."
}
