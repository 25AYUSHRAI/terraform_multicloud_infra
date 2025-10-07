variable "resource_name_prefix" {
  description = "Prefix for all resources created"
  type        = string
}

variable "resource_group_name" {
  description = "resource group"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string

}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}

}

variable "agw_pip_id" {
  description = "PIP agw"
  type        = string
}