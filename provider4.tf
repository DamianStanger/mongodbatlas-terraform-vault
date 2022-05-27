provider "mongodbatlas" {
  public_key  = data.vault_generic_secret.mongodbatlas.data["public_key"]
  private_key = data.vault_generic_secret.mongodbatlas.data["private_key"]
}

provider "vault" {
  address = "http://127.0.0.1:8200"
}

data "vault_generic_secret" "mongodbatlas" {
  path = "mongodbatlas/creds/test"
}
