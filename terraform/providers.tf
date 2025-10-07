terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  #   backend "azurerm" {
  #   use_oidc                         = true                                    # Can also be set via `ARM_USE_OIDC` environment variable.
  #   oidc_azure_service_connection_id = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_OIDC_AZURE_SERVICE_CONNECTION_ID` environment variable.
  #   use_azuread_auth                 = true                                    # Can also be set via `ARM_USE_AZUREAD` environment variable.
  #   tenant_id                        = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_TENANT_ID` environment variable.
  #   client_id                        = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_CLIENT_ID` environment variable.
  #   storage_account_name             = "abcd1234"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
  #   container_name                   = "tfstate"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
  #   key                              = "prod.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  # }
}

provider "azurerm" {
  subscription_id = "81636ff2-7700-48a9-8aa6-9270d1bc92ae"
  features {}
}