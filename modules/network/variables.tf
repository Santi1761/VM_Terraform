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

variable "address_space" {
  description = "Espacio de direcciones de la VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Prefijos de direcciones de la subred"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "Tags para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
