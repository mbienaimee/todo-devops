# variables.tf: This file defines the variables used in the Terraform configuration.

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "todo-devops-rg"
}

variable "app_name" {
  description = "The base name for the App Service and other resources."
  type        = string
  default     = "todo-devops-app"
}

variable "location" {
  description = "The Azure region to deploy the resources in."
  type        = string
  default     = "East US"
}
