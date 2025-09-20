output "public_ip" {
  description = "IP pública de la VM no modular"
  value       = azurerm_public_ip.pip.ip_address
}

output "ssh_command" {
  description = "Comando de conexión SSH"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}
