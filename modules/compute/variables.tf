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
  description = "ID de la interfaz de red"
  type        = string
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B1s"
  
  validation {
    condition = can(regex("^Standard_[A-Za-z0-9]+$", var.vm_size))
    error_message = "El tamaño de VM debe seguir el formato Standard_XXX."
  }
}

variable "admin_username" {
  description = "Usuario administrador de la VM"
  type        = string
  
  validation {
    condition     = length(var.admin_username) >= 3 && length(var.admin_username) <= 20
    error_message = "El nombre de usuario debe tener entre 3 y 20 caracteres."
  }
}

variable "admin_password" {
  description = "Contraseña del usuario admin (opcional si se usa SSH key)"
  type        = string
  sensitive   = true
  default     = null
  
  validation {
    condition = var.admin_password == null || (
      length(var.admin_password) >= 12 &&
      can(regex(".*[A-Z].*", var.admin_password)) &&
      can(regex(".*[a-z].*", var.admin_password)) &&
      can(regex(".*[0-9].*", var.admin_password)) &&
      can(regex(".*[^A-Za-z0-9].*", var.admin_password))
    )
    error_message = "La contraseña debe tener al menos 12 caracteres e incluir mayúsculas, minúsculas, números y símbolos."
  }
}

variable "use_ssh_key" {
  description = "Usar SSH key en lugar de contraseña"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "Clave pública SSH (opcional, se genera automáticamente si no se proporciona)"
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "ID del Key Vault para almacenar claves privadas"
  type        = string
  default     = null
}

# Image configuration
variable "image_publisher" {
  description = "Editor de la imagen"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Oferta de la imagen"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU de la imagen"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Versión de la imagen"
  type        = string
  default     = "latest"
}

# Disk configuration
variable "os_disk_type" {
  description = "Tipo de disco del SO"
  type        = string
  default     = "Premium_LRS"
  
  validation {
    condition = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "UltraSSD_LRS"], var.os_disk_type)
    error_message = "El tipo de disco debe ser uno de: Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS."
  }
}

variable "os_disk_size" {
  description = "Tamaño del disco del SO en GB"
  type        = number
  default     = 30
  
  validation {
    condition     = var.os_disk_size >= 30 && var.os_disk_size <= 4095
    error_message = "El tamaño del disco debe estar entre 30 y 4095 GB."
  }
}

variable "data_disk_size" {
  description = "Tamaño del disco de datos en GB (0 para deshabilitar)"
  type        = number
  default     = 0
  
  validation {
    condition     = var.data_disk_size >= 0 && var.data_disk_size <= 32767
    error_message = "El tamaño del disco de datos debe estar entre 0 y 32767 GB."
  }
}

variable "data_disk_type" {
  description = "Tipo de disco de datos"
  type        = string
  default     = "Premium_LRS"
  
  validation {
    condition = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "UltraSSD_LRS"], var.data_disk_type)
    error_message = "El tipo de disco debe ser uno de: Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS."
  }
}

variable "boot_diagnostics_storage_uri" {
  description = "URI de la cuenta de almacenamiento para boot diagnostics"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
