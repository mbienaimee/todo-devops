# This is an example of what your providers.tf should look like.
# It includes the required_providers block.
# Please ensure you have this block in only ONE file.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# The actual provider configuration can go here.
provider "azurerm" {
  features {}
}
