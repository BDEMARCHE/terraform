terraform {
  required_version = ">= 1.1.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.57.0"
    }
    fakewebservices = "~> 0.1"
  }

  backend "remote" {
    organization = {{ORGANIZATION_NAME}}
    workspaces {
      name = "{{WORKSPACE_NAME}}"
    }
  }

}

variable "provider_token" {
  type      = string
  sensitive = true
  default = "lLXMHxKH45OyqQ.atlasv1.0nJ3lBkloRy4m7s85UzawiKeMDJt4YLL6BKrXfMXNdyNz2KkYshfvLR5jY0rVhEdAI4"
}

provider "fakewebservices" {
  token = "pLh5b4Fl4LzOyw.atlasv1.BDbSL7T8vCrDe8t0EEwxHXL7kU2Tjerkdonvi2hAduzHNNlLzKa4pyuhIEgYHWGaxnE"
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
