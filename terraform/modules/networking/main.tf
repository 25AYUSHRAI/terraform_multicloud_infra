# Vnet
resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_name_prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Public subnet for frontend resources
resource "azurerm_subnet" "public" {
  count                = length(var.public_subnet_prefixes)
  name                 = "${var.resource_name_prefix}-public-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_prefixes[count.index]]

}

# Private subnet for backend resources
resource "azurerm_subnet" "private" {
  count                = length(var.private_subnet_prefixes)
  name                 = "${var.resource_name_prefix}-private-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_prefixes[count.index]]

}

# # NSG public subnet
# resource "azurerm_network_security_group" "public_nsg" {
#   name                = "${var.resource_name_prefix}-public-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags

#   security_rule {
#     name                       = "Allow-HTTP"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "Allow-HTTPS"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "AllowAppGwV2Inbound"
#     priority                   = 120
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_ranges    = ["65200-65535"]
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# Private Subnet NSG
resource "azurerm_network_security_group" "private" {
  name                = "${var.resource_name_prefix}-private-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowBackendAppPort"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = var.vnet_address_space
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowInternetOutbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# # NSG association public subnet
# resource "azurerm_subnet_network_security_group_association" "public_nsg_assoc" {
#   count                     = length(azurerm_subnet.public)
#   subnet_id                 = azurerm_subnet.public[count.index].id
#   network_security_group_id = azurerm_network_security_group.public_nsg.id
# }

# NSG association private subnet
resource "azurerm_subnet_network_security_group_association" "private_nsg_assoc" {
  count                     = length(azurerm_subnet.private)
  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.private.id
}

# Public IP for AGW
resource "azurerm_public_ip" "agw_pip" {
  name                = "${var.resource_name_prefix}-agw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat_pip" {
  name                = "${var.resource_name_prefix}-nat-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# NAT
resource "azurerm_nat_gateway" "main" {
  name                = "${var.resource_name_prefix}-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  tags                = var.tags
}

# NAT association public IP
resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

# NAT association private subnets
resource "azurerm_subnet_nat_gateway_association" "nat_assoc" {
  count          = length((azurerm_subnet.private))
  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.main.id
}