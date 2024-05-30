variable "rg_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The location for Azure resources"
}

variable "subnet_name" {
  description = "The name of the subnet"
}

variable "blob_container_name" {
  description = "The name of the blob container"
}

variable "storage_account_access_key" {
  description = "The access key for the storage account"
}

variable "storage_account_name" {
  description = "The name of the storage account"
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
}

variable "loader_image" {
  description = "The Docker image for the loader container"
}

variable "ui_image" {
  description = "The Docker image for the UI container"
}

variable "maintenance_image" {
  description = "The Docker image for the maintenance container"
}

variable "rest_image" {
  description = "The Docker image for the REST container"
}
