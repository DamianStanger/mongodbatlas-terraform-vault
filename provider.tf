provider "mongodbatlas" {
  # method 1
  # public_key = var.mongodbatlas_temp_public_key
  # private_key  = var.mongodbatlas_temp_private_key

  #method 2
  # public_key = vault_database_secrets_mount.db.mongodbatlas[0].public_key
  # private_key  = vault_database_secrets_mount.db.mongodbatlas[0].private_key
  
  #method 3
  public_key = vault_database_secret_backend_connection.db2.mongodbatlas[0].public_key
  private_key  = vault_database_secret_backend_connection.db2.mongodbatlas[0].private_key
}


# method 2
# provider "vault" {
#   address = "http://127.0.0.1:8200"
# }

# resource "vault_database_secrets_mount" "db" {
#   path = "db"

#   mongodbatlas {
#     name = "foo"
#     public_key = var.mongodbatlas_org_public_key
#     private_key = var.mongodbatlas_org_private_key
#     project_id = "100000000000000000000001"
#   }
# }


# method 3
resource "vault_mount" "db1" {
  path = "mongodbatlas01"
  type = "database"
}

resource "vault_database_secret_backend_connection" "db2" {
  backend       = vault_mount.db1.path
  name          = "mongodbatlas02"
  allowed_roles = ["dev", "prod"]

  mongodbatlas {
    public_key = var.mongodbatlas_org_public_key
    private_key = var.mongodbatlas_org_private_key
    project_id = "100000000000000000000001"
  }
}