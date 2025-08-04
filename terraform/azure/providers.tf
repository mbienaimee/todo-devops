# This file defines the providers and their versions.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
}

# The rest of your provider configuration goes here
# This provider block now explicitly uses a variable for the subscription ID.
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id

  # This flag prevents Terraform from trying to register all
  # supported resource providers. This fixes the error you
  # were seeing with Microsoft.Media and Microsoft.TimeSeriesInsights.
  skip_provider_registration = true
}

# Define the variable that will hold your Azure subscription ID.
# This variable is referenced in the provider block above.
variable "azure_subscription_id" {
  type        = string
  description = "The Azure subscription ID to deploy to."
}
