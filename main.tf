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
    fakewebservices = "~> 0.1"
  }
}

variable "provider_token" {
  type      = string
  sensitive = true
}

provider "fakewebservices" {
  token = var.provider_token
}

resource "fakewebservices_vpc" "primary_vpc" {
  name       = "Primary VPC"
  cidr_block = "0.0.0.0/1"
}

resource "fakewebservices_server" "servers" {
  count = 2

  name = "Server ${count.index + 1}"
  type = "t2.micro"
  vpc  = fakewebservices_vpc.primary_vpc.name
}

resource "fakewebservices_load_balancer" "primary_lb" {
  name    = "Primary Load Balancer"
  servers = fakewebservices_server.servers[*].name
}

resource "fakewebservices_database" "prod_db" {
  name = "Production DB"
  size = 256
}
