# variables.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
  default     = "todo-devops-rg"
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "southafricanorth" # Changed to South Africa North
  # Alternative stable regions if capacity issues arise:
  # default = "westus"
  # default = "westeurope"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry."
  type        = string
  default     = "tododevopsregistry"
}

variable "cosmosdb_account_name" {
  description = "Name of the Azure Cosmos DB account."
  type        = string
  default     = "tododevopscosmosdb"
}

variable "aca_environment_name" {
  description = "Name of the Azure Container Apps Environment."
  type        = string
  default     = "todo-devops-aca-env"
}

variable "docker_username" {
  description = "Your Docker Hub username used for tagging images (e.g., yourdockerusername)"
  type        = string
  # No default here, as it's sensitive and specific to you.
  # You will provide this via -var="docker_username=..." or terraform.tfvars.
}