# This file defines the required versions for Terraform and its providers.
# The `backend` block has been removed here to avoid conflicts with the
# GitHub Actions workflow, which will configure the backend for us.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
