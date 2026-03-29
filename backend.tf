terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-stage-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}