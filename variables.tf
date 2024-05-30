variable "environment" {
  description = "The environment to deploy (Dev, SIT, UAT, PRD)"
  type        = string
  default     = "Dev"
  validation {
    condition     = contains(["Dev", "SIT", "UAT", "PRD"], var.environment)
    error_message = "Environment must be one of Dev, SIT, UAT, PRD."
  }
}

variable "prefix" {
  description = "Constant prefix for all resources"
  type        = string
  default     = "fmkb"
}

variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-migration-project"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "East US"
}

variable "location_code" {
  description = "Short code for the location (e.g., weeu for West Europe)"
  type        = string
  default     = "eust"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-migration"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet-default"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "vm-linux-migration"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  default     = "ComplexPassword123!" # Ideally, store this in Azure Key Vault
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
  default     = "nsg-vm-linux"
}

variable "service_plan_name" {
  description = "The name of the app service plan"
  type        = string
  default     = "migration-service-plan"
}

variable "function_app_name" {
  description = "The name of the function app"
  type        = string
  default     = "migration-function-app"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "mymigrationstorage"
}

variable "blob_container_name" {
  description = "The name of the blob container"
  type        = string
  default     = "migration-files"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "D4as_v5" // 4 vCPUs, 16 GB RAM
}

variable "disk_size" {
  description = "The size of the virtual machine disk"
  type        = number
  default     = 128 // 128 GB SSD
}

variable "loader_image" {
  description = "Container image for the Loader instance"
  type        = string
  default     = "loader_image"
}

variable "ui_image" {
  description = "Container image for the UI instance"
  type        = string
  default     = "ui_image"
}

variable "maintenance_image" {
  description = "Container image for the Maintenance instance"
  type        = string
  default     = "maintenance_image"
}

variable "rest_image" {
  description = "Container image for the REST instance"
  type        = string
  default     = "rest_image"
}
