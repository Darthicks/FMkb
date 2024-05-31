variable "environment" {
  description = "The environment for the resources (Dev/Acc/Prod)"
  type        = string
}

variable "location_code" {
  description = "The location code (e.g., weeu)"
  type        = string
}

variable "random_number" {
  description = "A random number for uniqueness"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for VM"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "blob_container_name" {
  description = "The name of the blob container"
  type        = string
}

variable "loader_image" {
  description = "The image for the loader container"
  type        = string
}

variable "ui_image" {
  description = "The image for the UI container"
  type        = string
}

variable "maintenance_image" {
  description = "The image for the maintenance container"
  type        = string
}

variable "rest_image" {
  description = "The image for the rest container"
  type        = string
}

variable "location" {
  description = "The Azure location for the resources"
  type        = string
}
