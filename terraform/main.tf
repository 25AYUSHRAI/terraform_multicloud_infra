resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source                  = "./modules/networking"
  resource_name_prefix    = var.resource_name_prefix
  location                = var.location
  resource_group_name     = var.resource_group_name
  tags                    = var.tags
  vnet_address_space      = var.vnet_address_space
  public_subnet_prefixes  = var.public_subnet_prefixes
  private_subnet_prefixes = var.private_subnet_prefixes
  # agw_subnet_prefixes = var.agw_subnet_prefixes
}

module "application-gateway" {
  source               = "./modules/appgw"
  resource_name_prefix = var.resource_name_prefix
  location             = var.location
  resource_group_name  = var.resource_group_name
  tags                 = var.tags
  subnet_id            = module.networking.public_subnet_ids[0]
  # subnet_id = module.networking.azurerm_subnet.public[0].id
  agw_pip_id = module.networking.agw_pip_id
}

module "compute" {
  source                                       = "./modules/compute"
  resource_name_prefix                         = var.resource_name_prefix
  location                                     = var.location
  resource_group_name                          = var.resource_group_name
  subnet_id                                    = module.networking.private_subnet_ids[0]
  tags                                         = var.tags
  environment                                  = var.environment
  admin_username                               = var.admin_username
  admin_password                               = var.admin_password
  application_gateway_backend_address_pool_ids = module.application-gateway.agw_backend_address_pool_id
  docker_image                                 = var.docker_image
}
