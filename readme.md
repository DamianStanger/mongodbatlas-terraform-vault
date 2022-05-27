# Mongo Atlas setup

Sign up for a free account https://www.mongodb.com/atlas/database

Create a new project and note its project ID.

Create an organisation API key with role "Organization Owner", ideally with a restricted CIDR notated IP range (https://cidr.xyz).


# Vault setup

Install vault as per https://learn.hashicorp.com/tutorials/vault/getting-started-install

```bash
vault server -dev
export VAULT_ADDR='http://127.0.0.1:8200'
vault status
vault secrets enable mongodbatlas
vault secrets list
# Write your master API keys into vault
vault write mongodbatlas/config public_key=org-api-public-key private_key=org-api-private-key
vault write mongodbatlas/roles/test project_id=100000000000000000000001 roles=GROUP_OWNER ttl=2h max_ttl=5h cidr_blocks=123.45.67.1/24
vault read mongodbatlas/roles/test
vault token lookup
# Get some temporary keys
vault read mongodbatlas/creds/test
```

## Errors

Error creating programmatic api key .... IP address xxx.xxx.xxx.xxx is not allowed to access this resource.

Ensure your public ip address is in the mongo atlas policy for the master api key cidr range (https://cidr.xyz).

```bash
curl ifconfig.me
dig @resolver1.opendns.com myip.opendns.com
```

## test your temp keys using the admin api

```bash
curl -X GET -u "temp-public-key:temp-private-key" --digest -i "https://cloud.mongodb.com/api/atlas/v1.0"
```

Docs here: https://www.mongodb.com/docs/atlas/reference/api/apiKeys

# Terraform

Install terraform as per https://learn.hashicorp.com/tutorials/terraform/install-cli

``` bash
# set the project id
export TF_VAR_mongodbatlas_project_id=100000000000000000000001

# used when manually setting the keys
export TF_VAR_mongodbatlas_temp_public_key=temp-public-key
export TF_VAR_mongodbatlas_temp_private_key=temp-private-key

# used when using dynamic secrets in terraform
export TF_VAR_mongodbatlas_org_public_key=org-api-public-key
export TF_VAR_mongodbatlas_org_private_key=org-api-private-key

terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

# The different provider files
There are 4 different provider files, to switch between them add and remove the trailing underscore. Why are there 4? well i was trying all sorts to get the dynamic ephemeral credentials via vault working, and it took a while but in the end its working. TLDR; use provider4.tf

## provider1.tf
This is how you would use atlas + terraform with no vault integration, you manually put your atlas API keys in to the environment

``` bash
export TF_VAR_mongodbatlas_project_id=100000000000000000000001
# un-comment the relevant variables in variables.tf
export TF_VAR_mongodbatlas_temp_public_key=temp-public-key
export TF_VAR_mongodbatlas_temp_private_key=temp-private-key
```

## provider2.tf and provider3.tf
These two are different methods of trying to get secrets from vault to use to connect to atlas. 
They both would use org level API keys to attempt to generate dynamic keys to use in the actual building of infrastructure by terraform.

``` bash
export TF_VAR_mongodbatlas_project_id=100000000000000000000001
# un-comment the relevant variables in variables.tf
export TF_VAR_mongodbatlas_org_public_key=org-api-public-key
export TF_VAR_mongodbatlas_org_private_key=org-api-private-key
```

Actually these are trying to provision vault rather than use vault. My naive understanding of vault and how it integrates with atlas and terraform was to blame, that and the dearth of examples of doing this with mongo atlas.

## provider4.tf
This is the working provider :-) yay

``` bash
export TF_VAR_mongodbatlas_project_id=100000000000000000000001
```

Once you have set the project id and run `terraform apply` you should see some new keys being created in your atlas console with access to your project. And crucially your should see a new cluster getting created :-)


# Links

- Building mongo atlas infrastructure with terraform https://www.mongodb.com/atlas/hashicorp-terraform
- Manage mongo DB secrets with vault https://www.mongodb.com/atlas/hashicorp-vault
- MongoDBAtlas terraform provider docs https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs
- Vault terraform provider docs https://registry.terraform.io/providers/hashicorp/vault/latest/docs
- MongoDBAtlas vault secrets engine https://www.vaultproject.io/docs/secrets/mongodbatlas
- Manage MongoDB Atlas Database Secrets in HashiCorp Vault https://www.mongodb.com/blog/post/manage-atlas-database-secrets-hashicorp-vault
