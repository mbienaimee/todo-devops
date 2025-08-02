# terraform/azure/variables.tf

# Defines the variables used in the Terraform configuration.
variable "environment" {
  description = "The environment name (e.g., 'production' or 'staging')."
  type        = string
  default     = "staging"
}

variable "location" {
  description = "The Azure region for resources."
  type        = string
  default     = "southafricanorth"
}
