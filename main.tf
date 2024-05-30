provider "azurerm" {
  features {}
}

provider "random" {
  # no configuration required
}

# Generate random IDs for uniqueness
resource "random_id" "vnet" {
  byte_length = 2
}

resource "random_id" "nsg" {
  byte_length = 2
}

resource "random_id" "vm" {
  byte_length = 2
}

resource "random_id" "storage" {
  byte_length = 2
}

resource "random_id" "service_plan" {
  byte_length = 2
}

resource "random_id" "function_app" {
  byte_length = 2
}

resource "random_id" "aci_loader" {
  byte_length = 2
}

resource "random_id" "aci_ui" {
  byte_length = 2
}

resource "random_id" "aci_maintenance" {
  byte_length = 2
}

resource "random_id" "aci_rest" {
  byte_length = 2
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-${var.rg_name}-${var.location_code}"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-${var.environment}-vnet${random_id.vnet.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "${var.prefix}-${var.environment}-${var.subnet_name}-${var.location_code}"
    address_prefix = "10.0.1.0/24"
  }
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-${var.environment}-nsg${random_id.nsg.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-http"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "80"
    priority                   = 100
  }

  security_rule {
    name                       = "allow-https"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "443"
    priority                   = 200
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}-${var.environment}-vm${random_id.vm.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.disk_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Network Interface for the VM
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.prefix}-${var.environment}-nic${random_id.vm.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.vnet.subnet[0].id
    private_ip_address_allocation = "Dynamic"
  }
}

# App Service Plan
resource "azurerm_app_service_plan" "service_plan" {
  name                = "${var.prefix}-${var.environment}-asp${random_id.service_plan.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.prefix}${var.environment}stg${random_id.storage.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container
resource "azurerm_storage_container" "blob_container" {
  name                  = "${var.blob_container_name}-${var.environment}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

# Function App
resource "azurerm_function_app" "function_app" {
  name                = "${var.prefix}-${var.environment}-fa${random_id.function_app.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.service_plan.id

  app_settings = {
    "AzureWebJobsStorage"         = azurerm_storage_account.storage_account.primary_blob_endpoint
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "FUNCTIONS_WORKER_RUNTIME"    = "node"
  }
}

# Function App Function (Blob Trigger)
resource "azurerm_function_app_function" "blob_trigger" {
  name            = "BlobTriggerFunction"
  function_name   = "BlobTriggerFunction"
  function_app_id = azurerm_function_app.function_app.id

  app_settings = {
    "BlobTriggerPath" = "${var.blob_container_name}-${var.environment}/{name}"
  }
}

# Azure Container Instances

# Loader Container
resource "azurerm_container_group" "loader" {
  name                = "${var.prefix}-${var.environment}-loader${random_id.aci_loader.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "loader"
    image  = "your-loader-image:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "ENV" = var.environment
    }
  }

  ip_address {
    type         = "public"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# UI Container
resource "azurerm_container_group" "ui" {
  name                = "${var.prefix}-${var.environment}-ui${random_id.aci_ui.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "ui"
    image  = "your-ui-image:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "ENV" = var.environment
    }
  }

  ip_address {
    type         = "public"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# Maintenance Container
resource "azurerm_container_group" "maintenance" {
  name                = "${var.prefix}-${var.environment}-maintenance${random_id.aci_maintenance.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "maintenance"
    image  = "your-maintenance-image:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "ENV" = var.environment
    }
  }

  ip_address {
    type         = "public"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# REST API Container
resource "azurerm_container_group" "rest" {
  name                = "${var.prefix}-${var.environment}-rest${random_id.aci_rest.hex}-${var.location_code}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "rest"
    image  = "your-rest-image:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "ENV" = var.environment
    }
  }

  ip_address {
    type         = "public"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# Outputs for debugging
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "function_app_name" {
  value = azurerm_function_app.function_app.name
}

output "loader_container_name" {
  value = azurerm_container_group.loader.name
}

output "ui_container_name" {
  value = azurerm_container_group.ui.name
}

output "maintenance_container_name" {
  value = azurerm_container_group.maintenance.name
}

output "rest_container_name" {
  value = azurerm_container_group.rest.name
}
