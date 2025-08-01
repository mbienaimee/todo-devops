# This file defines the required versions for Terraform and its providers.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # The backend block is removed here. The GitHub Actions workflow will
  # configure the backend using command-line arguments, which is the
  # correct and more robust approach for CI/CD pipelines.
}
