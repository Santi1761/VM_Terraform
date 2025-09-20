# Configuración para Terraform Cloud (opcional)
# Descomenta y configura si quieres usar Terraform Cloud como backend

# terraform {
#   cloud {
#     organization = "tu-organizacion"
#     workspaces {
#       name = "vm-terraform"
#     }
#   }
# }

# Configuración local (por defecto)
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
