variable "environment" {
  description = "The environment for deployment"
  type        = string
}

variable "location" {
  description = "The Azure location for resources"
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key for the storage account"
  type        = string
  sensitive   = true
}

variable "loader_image" {
  description = "The Docker image for the loader container"
  type        = string
}

variable "ui_image" {
  description = "The Docker image for the UI container"
  type        = string
}

variable "maintenance_image" {
  description = "The Docker image for the maintenance container"
  type        = string
}

variable "rest_image" {
  description = "The Docker image for the REST container"
  type        = string
}
