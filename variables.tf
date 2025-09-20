variable "prefix" {
  description = "Prefijo para nombrar recursos (solo minúsculas/números/guiones)."
  type        = string
}

variable "location" {
  description = "Región de Azure (ej: eastus)."
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "Tamaño de la VM."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Usuario administrador de la VM."
  type        = string
}

variable "admin_password" {
  description = "Contraseña del usuario admin (12+ caracteres, mayús/minús/número/símbolo)."
  type        = string
  sensitive   = true
}
