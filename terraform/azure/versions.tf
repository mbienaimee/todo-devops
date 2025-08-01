# This file defines the required versions for Terraform and its providers.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # The version constraint is set to accept any 4.x version.
      version = "~> 4.0"
    }
  }

  # The backend block is removed here because it is configured directly
  # by the GitHub Actions workflow using command-line arguments.
}
