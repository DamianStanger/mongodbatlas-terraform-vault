variable "mongodbatlas_project_id" {
  description = "project id from mongo db atlas"
  type        = string
}

variable "mongodbatlas_temp_public_key" {
  description = "temp public key for mongo db atlas interaction, used when manually setting the keys"
  type        = string
}

variable "mongodbatlas_temp_private_key" {
  description = "temp private key for mongo db atlas interaction, used when manually setting the keys"
  type        = string
}

variable "mongodbatlas_org_public_key" {
  description = "org public key for mongo db atlas interaction, used when using dynamic secrects in terraform"
  type        = string
}

variable "mongodbatlas_org_private_key" {
  description = "org_private key for mongo db atlas interaction, used when using dynamic secrects in terraform"
  type        = string
}