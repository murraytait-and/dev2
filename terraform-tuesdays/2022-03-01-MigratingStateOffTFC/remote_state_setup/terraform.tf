##################################################################################
# TERRAFORM CONFIG
##################################################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}


##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  features {}
}