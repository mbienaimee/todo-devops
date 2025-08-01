# ------------------------------------
# File: variables.tf
# Description: Defines input variables for the Terraform configuration.
# ------------------------------------

# The name of the resource group to create.
variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "todo-devops-rg"
}

# The Azure region where resources will be deployed.
variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "southafricanorth"
}

# The deployment environment (e.g., staging, production).
# This variable will be set by your GitHub Actions workflow.
variable "environment" {
  description = "The deployment environment (e.g., staging, production)."
  type        = string
}

