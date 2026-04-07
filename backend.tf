terraform {
  backend "azurerm" {
    resource_group_name  = "myresume-live-rg"
    storage_account_name = "preacherjefferson"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}