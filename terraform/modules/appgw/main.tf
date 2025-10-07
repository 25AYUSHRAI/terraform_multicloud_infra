
resource "azurerm_application_gateway" "main" {
  name                = "${var.resource_name_prefix}-agw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = var.agw_pip_id
  }

  backend_address_pool {
    name = "vmss-backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
    # probe_name = "health-probe"
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    # frontend_ip_configuration_id   = azurerm_application_gateway.main.frontend_ip_configuration[0].id
    frontend_port_name = "frontendPort"
    protocol           = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    priority = 100
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "vmss-backend-pool"
    backend_http_settings_name = "http-settings"
  }
  # probe {
  #   name                = "health-probe"
  #   protocol            = "Http"
  #   host                = "localhost"
  #   path                = "/"
  #   interval            = 30
  #   timeout             = 30
  #   unhealthy_threshold = 3
  #   match {
  #     status_codes = ["200-399"]
  #   }
  # }
  tags = var.tags
}