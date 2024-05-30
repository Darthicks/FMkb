provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(azurerm_virtual_network.vnet.subnet.*.id, 0)
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "myVM"
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
    name              = "myOSDisk"
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

resource "azurerm_service_plan" "service_plan" {
  name                = "myAppServicePlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "mystorageacct"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "${var.blob_container_name}-${var.environment}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_function_app" "function_app" {
  name                       = "myFunctionApp"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_service_plan.service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
}

resource "azurerm_container_group" "loader" {
  name                = "myLoader"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "loader"
    image  = "microsoft/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"
  }

  ip_address {
    ports = [
      {
        protocol = "TCP"
        port     = 80
      }
    ]
  }
}

resource "azurerm_container_group" "ui" {
  name                = "myUI"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "ui"
    image  = "microsoft/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"
  }

  ip_address {
    ports = [
      {
        protocol = "TCP"
        port     = 80
      }
    ]
  }
}

resource "azurerm_container_group" "maintenance" {
  name                = "myMaintenance"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "maintenance"
    image  = "microsoft/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"
  }

  ip_address {
    ports = [
      {
        protocol = "TCP"
        port     = 80
      }
    ]
  }
}

resource "azurerm_container_group" "rest" {
  name                = "myRest"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "rest"
    image  = "microsoft/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"
  }

  ip_address {
    ports = [
      {
        protocol = "TCP"
        port     = 80
      }
    ]
  }
}
