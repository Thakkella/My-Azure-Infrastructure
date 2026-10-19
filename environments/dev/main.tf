locals {
  common_tags = {
    Environment = var.env_prefix
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-infrastructure-${var.env_prefix}"
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source              = "../../modules/networking"
  vnet_name           = "vnet-${var.env_prefix}-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.10.0.0/16"]
  subnets = {
    "app-subnet" = { address_prefixes = ["10.10.1.0/24"] }
  }
  tags = local.common_tags
}

module "storage" {
  source              = "../../modules/storage"
  keyvault_name       = "kv-infra-secrets-${var.env_prefix}-05" # Ensure globally unique suffix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags
}

module "compute" {
  source              = "../../modules/compute"
  vm_name             = "vm-app-${var.env_prefix}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.networking.subnet_ids["app-subnet"]
  admin_password      = module.storage.vm_secret_val
  tags                = local.common_tags
}
