# Vault setup

Install vault as per https://learn.hashicorp.com/tutorials/vault/getting-started-install

Install terraform as per https://learn.hashicorp.com/tutorials/terraform/install-cli

```bash
vault server -dev
export VAULT_ADDR='http://127.0.0.1:8200'
vault status
vault secrets enable mongodbatlas
vault secrets list
# Write your master API keys into vault
vault write mongodbatlas/config public_key=xxxxxxzd private_key=00000006-0006-0006-0006-0000000000006
vault write mongodbatlas/roles/test project_id=100000000000000000009111 roles=GROUP_OWNER ttl=2h max_ttl=5h cidr_blocks=123.45.67.1/24
vault read mongodbatlas/roles/test
vault token lookup
# Get some temporary keys
vault read mongodbatlas/creds/test

# Error creating programmatic api key .... IP address xxx.xxx.xxx.xxx is not allowed to access this resource
curl ifconfig.me
dig @resolver1.opendns.com myip.opendns.com
# Ensure your public ip address is in the mongo atlas policy for the master api key cidr range


curl -X GET -u "temp-public-key:temp-private-key" --digest -i "https://cloud.mongodb.com/api/atlas/v1.0"
```

# Terraform
```
export TF_VAR_mongodbatlas_public_key=temp-public-key
export TF_VAR_mongodbatlas_private_key=temp-private-key

terraform init
terraform validate
terraform plan
# terraform apply
# terraform destroy
```


# Links

- Building mongo atlas infrastructure with terraform https://www.mongodb.com/atlas/hashicorp-terraform
- Manage mongo DB secrets with vault https://www.mongodb.com/atlas/hashicorp-vault
- MongoDBAtlas terraform provider docs https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs
- MongoDBAtlas vault secrets engine https://www.vaultproject.io/docs/secrets/mongodbatlas
- Manage MongoDB Atlas Database Secrets in HashiCorp Vault https://www.mongodb.com/blog/post/manage-atlas-database-secrets-hashicorp-vault
