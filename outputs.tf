output "public_ip" {
  description = "IP pública de la VM"
  value       = module.network.public_ip_address
}

output "private_ip" {
  description = "IP privada de la VM"
  value       = module.compute.vm_private_ip
}

output "vm_name" {
  description = "Nombre de la máquina virtual"
  value       = module.compute.vm_name
}

output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.rg.name
}

output "ssh_command" {
  description = "Comando de conexión SSH"
  value       = "ssh ${module.compute.vm_username}@${module.network.public_ip_address}"
}

output "ssh_private_key" {
  description = "Clave privada SSH (si se generó)"
  value       = module.compute.ssh_private_key
  sensitive   = true
}

output "ssh_public_key" {
  description = "Clave pública SSH"
  value       = module.compute.ssh_public_key
}

output "vm_id" {
  description = "ID de la máquina virtual"
  value       = module.compute.vm_id
}

output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "ID de la subred"
  value       = module.network.subnet_id
}
