# terraform/azure/variables.tf

variable "environment" {
  description = "The environment name (e.g., 'production' or 'staging')"
  type        = string
  default     = "production"
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
  default     = "southafricanorth" # Set your primary Azure region here
}