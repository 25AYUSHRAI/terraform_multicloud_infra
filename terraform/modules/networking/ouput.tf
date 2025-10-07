output "vnet_id" {
  description = "ID Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "public_subnet_ids" {
  description = "public subnets IDs"
  value       = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "private subnets IDs"
  value       = azurerm_subnet.private[*].id
}

# output "database_subnet_ids" {
#   description = "database subnets IDs"
#   value       = azurerm_subnet.database[*].id
# }

# output "appgw_subnet_id" {
#   description = "ID of the Application Gateway subnet"
#   value       = azurerm_subnet.agw.id
# }

output "agw_pip_id" {
  description = "Public IP ID for Application Gateway"
  value       = azurerm_public_ip.agw_pip.id
  
}

