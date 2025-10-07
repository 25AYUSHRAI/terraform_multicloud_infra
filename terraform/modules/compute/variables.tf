variable "resource_name_prefix" {
  description = "Prefix for all resource names."
  type        = string

}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string

}

variable "subnet_id" {
  description = "The ID of the subnet where the VMSS will be deployed."
  type        = string

}

variable "location" {
  description = "The Azure region to deploy resources in."
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

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)."
  type        = string

}

variable "application_gateway_backend_address_pool_ids" {
  description = "The ID of the Application Gateway backend address pool."
  type        = string

}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}

variable "docker_image" {
  description = "The Docker image to be pulled and run on the VM instances."
  type        = string

}