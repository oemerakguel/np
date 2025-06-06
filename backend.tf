terraform {
  backend "azurerm" {
    resource_group_name   = "rg-24-08-on-akgul-omer"
    storage_account_name  = "tfstateakgulomer01"
    container_name        = "tfstate"
    key                   = "terraform/state/np.tfstate"
  }
}
