terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-mgmt"
    storage_account_name = "sttfstateglobal001"
    container_name       = "tfstate-prod"       # Different isolated container target
    key                  = "prod.infrastructure.tfstate"
  }
}
