# terraform/azure/variables.tf

variable "environment" {
  description = "The environment name for the resources (e.g., dev, staging, prod)."
  type        = string
  default     = "staging"
}

variable "location" {
  description = "The Azure region to deploy the resources."
  type        = string
  default     = "SouthAfricaNorth"
}

variable "azure_subscription_id" {
  description = "The Azure subscription ID to deploy to."
  type        = string
}