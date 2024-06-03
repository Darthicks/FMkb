variable "environment" {

  description = "Environment (Dev/Acc/Prod)"

  type        = string

}

variable "location" {

  description = "Azure location"

  type        = string

}

variable "random_number" {

  description = "Random number for resource naming"

  type        = string

}

variable "rg_name" {

  description = "Name of the resource group"

  type        = string

  default     = ""

}

variable "subnet_name" {

  description = "Name of the subnet"

  type        = string

  default     = ""

}

variable "storage_account_name" {

  description = "Name of the storage account"

  type        = string

  default     = ""

}

variable "blob_container_name" {

  description = "Name of the blob container"

  type        = string

  default     = ""

}

variable "storage_account_access_key" {

  description = "Access key for the storage account"

  type        = string

  default     = ""

}

variable "loader_image" {

  description = "Docker image for loader container"

  type        = string

  default     = ""

}

variable "ui_image" {

  description = "Docker image for UI container"

  type        = string

  default     = ""

}

variable "maintenance_image" {

  description = "Docker image for maintenance container"

  type        = string

  default     = ""

}

variable "rest_image" {

  description = "Docker image for rest container"

  type        = string

  default     = ""

}
variable "port " {

  description = "TCP HTTP Port

  type        = string

  default     = "80"

}
