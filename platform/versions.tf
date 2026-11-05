terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Partial configuration: pass the values with
  #   terraform init -backend-config=backend.hcl
  backend "azurerm" {}
}

# Default provider: the management subscription (logging, policy, management groups).
provider "azurerm" {
  features {}
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}
