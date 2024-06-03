provider "azurerm" {
  features {}

  skip_provider_registration = true
}
terraform {

  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"

      version = "=2.81.0"  # Specify the desired version here

    }

  }

}

# Random number resource

resource "random_string" "random" {

  length  = 5

  special = false

  upper   = false

}

# Resource Group

resource "azurerm_resource_group" "rg" {

  name     = lower(format("fmkb_rg_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location = var.location

}

# Virtual Network

resource "azurerm_virtual_network" "vnet" {

  name                = lower(format("fmkb_vnet_%s_%s_%s", var.environment, random_string.random.result, var.location))

  address_space       = ["10.0.0.0/16"]

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

}

# Subnet

resource "azurerm_subnet" "subnet" {

  name                 = lower(format("fmkb_subnet_%s_%s_%s", var.environment, random_string.random.result, var.location))

  resource_group_name  = azurerm_resource_group.rg.name

  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes     = ["10.0.1.0/24"]

}

# Network Interface

resource "azurerm_network_interface" "vm_nic" {

  name                = lower(format("fmkb_nic_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {

    name                          = "internal"

    subnet_id                     = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

  }

}

# Virtual Machine

resource "azurerm_virtual_machine" "vm" {

  name                  = lower(format("fmkb_vm_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location              = azurerm_resource_group.rg.location

  resource_group_name   = azurerm_resource_group.rg.name

  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  vm_size               = "Standard_DS1_v2"

  os_profile {

    computer_name  = "hostname"

    admin_username = "adminuser"

    admin_password = "Password1234!"

  }

  os_profile_linux_config {

    disable_password_authentication = false

  }

  storage_os_disk {

    name              = lower(format("fmkb_osdisk_%s_%s_%s", var.environment, random_string.random.result, var.location))

    caching           = "ReadWrite"

    create_option     = "FromImage"

    managed_disk_type = "Standard_LRS"

  }

  storage_image_reference {

    publisher = "canonical"

    offer     = "UbuntuServer"

    sku       = "18.04-LTS"

    version   = "latest"

  }

}

# Storage Account

resource "azurerm_storage_account" "storage_account" {

  name                     = lower(format("fmkbsa%s%s", var.environment, random_string.random.result)) # Max length 24 characters

  resource_group_name      = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"

  account_replication_type = "LRS"

}

# Storage Container

resource "azurerm_storage_container" "blob_container" {

  name                  = lower(format("fmkb_blob_%s_%s_%s", var.environment, random_string.random.result, var.location))

  storage_account_name  = azurerm_storage_account.storage_account.name

  container_access_type = "private"

}

# Define the Azure App Service Plan

resource "azurerm_app_service_plan" "service_plan" {

  name                = lower(format("fmkb_sp_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"

  sku {

    tier = "Standard"

    size = "S1"

  }

}

# Define the Azure Function App

resource "azurerm_linux_function_app" "function_app" {

  name                       = lower(format("fmkb_func_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location                   = azurerm_resource_group.rg.location

  resource_group_name        = azurerm_resource_group.rg.name

  service_plan_id            = azurerm_app_service_plan.service_plan.id

  storage_account_name       = azurerm_storage_account.storage_account.name

  storage_account_access_key = var.storage_account_access_key

   app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "FUNCTIONS_WORKER_RUNTIME" = "java"
  }
site_config {
    always_on              = true
  }
}

}

# Container Groups

resource "azurerm_container_group" "loader" {

  name                = lower(format("fmkb_loader_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"

  container {

    name   = "loader"

    image  = var.loader_image

    cpu    = "0.5"

    memory = "1.5"

  }

}

resource "azurerm_container_group" "ui" {

  name                = lower(format("fmkb_ui_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"

  container {

    name   = "ui"

    image  = var.ui_image

    cpu    = "0.5"

    memory = "1.5"

  }

}

resource "azurerm_container_group" "maintenance" {

  name                = lower(format("fmkb_maintenance_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"

  container {

    name   = "maintenance"

    image  = var.maintenance_image

    cpu    = "0.5"

    memory = "1.5"

  }

}

resource "azurerm_container_group" "rest" {

  name                = lower(format("fmkb_rest_%s_%s_%s", var.environment, random_string.random.result, var.location))

  location            = azurerm_resource_group.rg.location

  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"

  container {

    name   = "rest"

    image  = var.rest_image

    cpu    = "0.5"

    memory = "1.5"

  }

}
