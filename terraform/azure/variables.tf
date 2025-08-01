# ------------------------------------
# File: variables.tf
# Description: Defines input variables for the Terraform configuration.
# ------------------------------------

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "todo-devops-rg"
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "southafricanorth"
}

variable "environment" {
  description = "The deployment environment (e.g., staging, production)."
  type        = string
}

# Add a variable for the Azure Container Registry name.
variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
  default     = "tdopsbienaimeetfstate" # This is a placeholder, you might want to use a unique name
}

