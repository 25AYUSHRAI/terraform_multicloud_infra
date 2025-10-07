variable "resource_name_prefix" {
  description = "Prefix for all resources created"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
}

variable "public_subnet_prefixes" {
  description = "List of address prefixes for public subnets"
  type        = list(string)
}

variable "private_subnet_prefixes" {
  description = "List of address prefixes for private subnets"
  type        = list(string)
}

# variable "agw_subnet_prefixes" {
#   description = "Address prefix for the Application Gateway subnet"
#   type        = string
# }

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)."
  type        = string

}

variable "admin_username" {
  description = "The admin username for the virtual machines."
  type        = string

}

variable "admin_password" {
  description = "The admin password for the virtual machines."
  type        = string
  sensitive   = true
}

variable "docker_image" {
  description = "The Docker image to be pulled and run on the VM instances."
  type        = string

}