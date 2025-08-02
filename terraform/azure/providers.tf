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
provider "azurerm" {
  features {}
}
