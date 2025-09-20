# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # SSH Rule - más restrictiva
  security_rule {
    name                       = "allow-ssh"
    description                = "Allow SSH access from specific IP ranges"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ssh_ips
    destination_address_prefix = "*"
  }

  # HTTP Rule (opcional)
  security_rule {
    name                       = "allow-http"
    description                = "Allow HTTP access"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 110
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTPS Rule (opcional)
  security_rule {
    name                       = "allow-https"
    description                = "Allow HTTPS access"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 120
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "deny-all-inbound"
    description                = "Deny all other inbound traffic"
    direction                  = "Inbound"
    access                     = "Deny"
    priority                   = 4000
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-nsg"
    Type = "Security"
  })
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = var.network_interface_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
