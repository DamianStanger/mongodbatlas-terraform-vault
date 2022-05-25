terraform {
  required_version = "~> 1.0"

  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.3.1"
    }
    vault   = {
      source  = "hashicorp/vault"
      version = "3.6.0"
    }
  }
}
