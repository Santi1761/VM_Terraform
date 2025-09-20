# Generate random password for admin user
resource "random_password" "admin_password" {
  count   = var.use_ssh_key ? 0 : 1
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Create SSH key pair if not provided
resource "tls_private_key" "ssh_key" {
  count     = var.use_ssh_key && var.ssh_public_key == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store SSH private key in Azure Key Vault (if Key Vault is available)
resource "azurerm_key_vault_secret" "ssh_private_key" {
  count        = var.use_ssh_key && var.ssh_public_key == null && var.key_vault_id != null ? 1 : 0
  name         = "${var.prefix}-ssh-private-key"
  value        = tls_private_key.ssh_key[0].private_key_pem
  key_vault_id = var.key_vault_id

  tags = var.tags
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  admin_username                  = var.admin_username
  admin_password                  = var.use_ssh_key ? null : (var.admin_password != null ? var.admin_password : random_password.admin_password[0].result)
  disable_password_authentication = var.use_ssh_key

  # SSH Key configuration
  dynamic "admin_ssh_key" {
    for_each = var.use_ssh_key ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key != null ? var.ssh_public_key : tls_private_key.ssh_key[0].public_key_openssh
    }
  }

  network_interface_ids = [var.network_interface_id]

  os_disk {
    name                 = "${var.prefix}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  # Source image reference
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  computer_name = var.prefix

  # Boot diagnostics
  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  # Additional capabilities
  allow_extension_operations = true
  patch_mode                 = "AutomaticByPlatform"

  tags = merge(var.tags, {
    Name = "${var.prefix}-vm"
    Type = "Compute"
  })

  lifecycle {
    ignore_changes = [
      admin_password,
      admin_ssh_key
    ]
  }
}

# Managed Disk for data (optional)
resource "azurerm_managed_disk" "data_disk" {
  count                = var.data_disk_size > 0 ? 1 : 0
  name                 = "${var.prefix}-datadisk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.data_disk_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size

  tags = merge(var.tags, {
    Name = "${var.prefix}-datadisk"
    Type = "Storage"
  })
}

# Attach data disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count              = var.data_disk_size > 0 ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.data_disk[0].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}
