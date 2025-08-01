# ------------------------------------
# File: variables.tf
# Description: Defines input variables for the Terraform configuration.
# ------------------------------------

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

# The name of the Azure Container Registry.
variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
  default     = "tdopsbienaimeetfstate"
}
