# This file defines the required versions for Terraform and its providers.
# It ensures that you are using a compatible version of the Azure provider.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # The version constraint has been updated to accept any 4.x version,
      # which resolves the conflict you were seeing.
      version = "~> 4.0"
    }
  }

  # The backend block specifies where Terraform should store its state.
  backend "azurerm" {
    # These values will be set via the GitHub Actions runner.
  }
}
