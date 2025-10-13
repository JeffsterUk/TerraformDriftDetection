terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "4.43.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = "539fe1f3-3901-4080-a6b2-2663bb5a0cd8"
  tenant_id                       = "23094f0b-5e78-428d-a15e-d74f0eb71d6a"
  resource_provider_registrations = "none"
}

resource "azurerm_virtual_network" "demo" {
  name                = "POC-TDD-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = "North Europe"
  resource_group_name = "POC-TDD-RG"
}