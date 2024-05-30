variable "blob_container_name" {
  description = "The name of the blob container"
}

variable "environment" {
  description = "The environment name"
}

variable "storage_account_access_key" {
  description = "The access key for the storage account"
}

variable "storage_account_name" {
  description = "The name of the storage account"
}

variable "location" {
  description = "The location for the resources"
}

variable "loader_image" {
  description = "The image for the loader container"
}

variable "ui_image" {
  description = "The image for the UI container"
}

variable "maintenance_image" {
  description = "The image for the maintenance container"
}

variable "rest_image" {
  description = "The image for the REST container"
}
