variable "prefix" {
  description = "Prefijo para nombrar recursos (solo minúsculas/números/guiones)."
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix)) && length(var.prefix) <= 20
    error_message = "El prefijo debe contener solo minúsculas, números y guiones, y tener máximo 20 caracteres."
  }
}

variable "location" {
  description = "Región de Azure (ej: eastus)."
  type        = string
  default     = "eastus"
  
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", "centralus", "northcentralus",
      "southcentralus", "northeurope", "westeurope", "eastasia", "southeastasia",
      "japaneast", "japanwest", "australiaeast", "australiasoutheast", "brazilsouth",
      "canadacentral", "canadaeast", "centralindia", "southindia", "westindia",
      "koreacentral", "koreasouth", "francecentral", "francesouth", "ukwest",
      "uksouth", "germanywestcentral", "germanynorth", "norwayeast", "norwaywest",
      "switzerlandnorth", "switzerlandwest", "uaenorth", "uaecentral", "southafricanorth",
      "southafricawest", "australiacentral", "australiacentral2", "jioindiawest",
      "jioindiacentral", "jioindiaeast", "swedencentral", "swedensouth", "polandcentral",
      "italynorth", "israelcentral", "qatarcentral", "spaincentral", "mexicocentral",
      "chilecentral", "peruwest", "colombiawest", "southcentralusstage", "westcentralus",
      "westus3", "eastus2euap", "centraluseuap", "brazilsoutheast", "jioindiacentral2",
      "eastus2stage", "westus2stage", "eastusstage", "westusstage", "centralusstage",
      "northcentralusstage", "southcentralusstage", "westcentralusstage", "eastus2euap",
      "centraluseuap", "westus2euap", "westus3euap", "eastus2stage", "westus2stage",
      "eastusstage", "westusstage", "centralusstage", "northcentralusstage",
      "southcentralusstage", "westcentralusstage", "eastus2euap", "centraluseuap",
      "westus2euap", "westus3euap"
    ], var.location)
    error_message = "La región debe ser una región válida de Azure."
  }
}

variable "vm_size" {
  description = "Tamaño de la VM."
  type        = string
  default     = "Standard_B1s"
  
  validation {
    condition = can(regex("^Standard_[A-Za-z0-9]+$", var.vm_size))
    error_message = "El tamaño de VM debe seguir el formato Standard_XXX."
  }
}

variable "admin_username" {
  description = "Usuario administrador de la VM."
  type        = string
  
  validation {
    condition     = length(var.admin_username) >= 3 && length(var.admin_username) <= 20
    error_message = "El nombre de usuario debe tener entre 3 y 20 caracteres."
  }
}

variable "admin_password" {
  description = "Contraseña del usuario admin (12+ caracteres, mayús/minús/número/símbolo)."
  type        = string
  sensitive   = true
  
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

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, staging, prod."
  }
}

variable "allowed_ssh_ips" {
  description = "Lista de IPs permitidas para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags adicionales para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
