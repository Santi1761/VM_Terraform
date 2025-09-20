terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Local values for common tags
locals {
  common_tags = merge({
    Environment = var.environment
    Owner       = var.prefix
    Project     = "VM-Terraform"
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }, var.tags)
}

############################
# 1. Resource Group
############################
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
  
  tags = local.common_tags
}

############################
# 2. Storage Account for Boot Diagnostics
############################
resource "azurerm_storage_account" "boot_diagnostics" {
  name                     = "${replace(var.prefix, "-", "")}${var.environment}bootdiag"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

############################
# 3. Network Module
############################
module "network" {
  source = "./modules/network"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]
  tags                = local.common_tags
}

############################
# 4. Security Module
############################
module "security" {
  source = "./modules/security"

  prefix                = var.prefix
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_id  = module.network.network_interface_id
  allowed_ssh_ips       = var.allowed_ssh_ips
  tags                  = local.common_tags
}

############################
# 5. Compute Module
############################
module "compute" {
  source = "./modules/compute"

  prefix                        = var.prefix
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_id          = module.network.network_interface_id
  vm_size                       = var.vm_size
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  use_ssh_key                   = var.use_ssh_key
  ssh_public_key                = var.ssh_public_key
  boot_diagnostics_storage_uri  = azurerm_storage_account.boot_diagnostics.primary_blob_endpoint
  data_disk_size                = var.environment == "prod" ? 100 : 0
  tags                          = local.common_tags
}
