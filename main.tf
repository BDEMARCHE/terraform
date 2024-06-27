terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  cloud {
    organization = "M2I"
    workspaces {
      name = "terraform"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }
}
