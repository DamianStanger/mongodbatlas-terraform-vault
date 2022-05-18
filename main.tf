resource "mongodbatlas_cluster" "cluster-terraform01" {
  project_id              = "100000000000000000000001"
  name                    = "cluster-terraform01"

  provider_name = "TENANT"
  backing_provider_name = "AWS"
  provider_region_name = "EU_WEST_1"
  provider_instance_size_name = "M0"
}