resource_name_prefix = "dev"
location = "Central India"
resource_group_name = "rg-dev-01"
tags = {
  environment = "dev"
  project     = "midsem-project"
}
vnet_address_space = "10.0.0.0/16"
public_subnet_prefixes = ["10.0.1.0/24"]
private_subnet_prefixes = ["10.0.2.0/24"]
# agw_subnet_prefixes = "10.0.3.0/24"
environment = "dev"
admin_username = "azureuser"
admin_password = "pass@1234"
docker_image = "nginx:latest"