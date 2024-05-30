output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Name of the virtual network"
}

output "vm_name" {
  value       = azurerm_virtual_machine.vm.name
  description = "Name of the virtual machine"
}

output "nsg_name" {
  value       = azurerm_network_security_group.nsg.name
  description = "Name of the network security group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage_account.name
  description = "Name of the storage account"
}

output "function_app_name" {
  value       = azurerm_function_app.function_app.name
  description = "Name of the function app"
}

output "function_app_url" {
  value       = azurerm_function_app.function_app.default_host_name
  description = "URL of the function app"
}

output "loader_container_name" {
  value       = azurerm_container_group.loader.name
  description = "Name of the loader container instance"
}

output "ui_container_name" {
  value       = azurerm_container_group.ui.name
  description = "Name of the UI container instance"
}

output "maintenance_container_name" {
  value       = azurerm_container_group.maintenance.name
  description = "Name of the maintenance container instance"
}

output "rest_container_name" {
  value       = azurerm_container_group.rest.name
  description = "Name of the REST container instance"
}
