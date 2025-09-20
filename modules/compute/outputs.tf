output "vm_id" {
  description = "ID de la máquina virtual"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Nombre de la máquina virtual"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "IP privada de la VM"
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "vm_public_ip" {
  description = "IP pública de la VM"
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "vm_username" {
  description = "Nombre de usuario de la VM"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

output "ssh_private_key" {
  description = "Clave privada SSH (si se generó)"
  value       = var.use_ssh_key && var.ssh_public_key == null ? tls_private_key.ssh_key[0].private_key_pem : null
  sensitive   = true
}

output "ssh_public_key" {
  description = "Clave pública SSH"
  value       = var.use_ssh_key && var.ssh_public_key == null ? tls_private_key.ssh_key[0].public_key_openssh : var.ssh_public_key
}

output "data_disk_id" {
  description = "ID del disco de datos (si existe)"
  value       = var.data_disk_size > 0 ? azurerm_managed_disk.data_disk[0].id : null
}
