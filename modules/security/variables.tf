variable "prefix" {
  description = "Prefijo para nombrar recursos"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "network_interface_id" {
  description = "ID de la interfaz de red a la que asociar el NSG"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "Lista de IPs permitidas para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Por defecto permite todo, pero se debe restringir en producción
}

variable "tags" {
  description = "Tags para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
