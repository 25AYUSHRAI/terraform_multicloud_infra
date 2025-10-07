output "agw_id" {
  description = "Application Gateway ID"
  value       = azurerm_application_gateway.main.id
}

output "agw_pip_id" {
  description = "Application Gateway Public IP ID"
  value       = azurerm_application_gateway.main.frontend_ip_configuration[0].public_ip_address_id
}

output "backend_http_settings" {
  description = "backend http settings"
  value       = azurerm_application_gateway.main.backend_http_settings[*].id
}

output "agw_backend_address_pool_id" {
  description = "Application Gateway backend address pool ID"
  value = one([
    for pool in azurerm_application_gateway.main.backend_address_pool : pool.id
    if pool.name == "vmss-backend-pool"
  ])
  
}