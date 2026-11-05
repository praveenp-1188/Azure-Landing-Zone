terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Partial configuration, one state file per environment:
  #   terraform init -backend-config=backend.hcl -backend-config="key=corp-dev.tfstate"
  backend "azurerm" {}
}

# Default provider: the workload (landing zone) subscription.
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# The hub side of the peering lives in the connectivity subscription.
provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = var.connectivity_subscription_id
}
