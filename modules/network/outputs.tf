output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Nombre de la Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  description = "ID de la subred"
  value       = azurerm_subnet.subnet.id
}

output "subnet_name" {
  description = "Nombre de la subred"
  value       = azurerm_subnet.subnet.name
}

output "public_ip_id" {
  description = "ID de la IP pública"
  value       = azurerm_public_ip.pip.id
}

output "public_ip_address" {
  description = "Dirección IP pública"
  value       = azurerm_public_ip.pip.ip_address
}

output "network_interface_id" {
  description = "ID de la interfaz de red"
  value       = azurerm_network_interface.nic.id
}

output "network_interface_name" {
  description = "Nombre de la interfaz de red"
  value       = azurerm_network_interface.nic.name
}
