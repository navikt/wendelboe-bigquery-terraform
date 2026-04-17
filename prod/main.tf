terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.40.0"
    }
  }
  backend "gcs" {
    bucket = "wendelboe-bigquery-terraform-state-prod"
  }
}

provider "google" {
  project = var.gcp_project["project"]
  region  = var.gcp_project["region"]
}

data "google_project" "project" {}

module "google_storage_bucket" {
  source = "../modules/google-cloud-storage"

  name     = "wendelboe-bigquery-terraform-state-prod"
  location = var.gcp_project["region"]
}

# Make a workload pool for pensjon-analyse-bq repo
module "google_bigquery_workload_pool" {
  source = "../modules/google-bigquery-workload-pool"

  project_id     = var.gcp_project["project"]
  grants         = ["roles/bigquery.dataOwner", "roles/bigquery.user"]
  repo_full_name = "navikt/pensjon-analyse-bq"
}

# Make a GCS bucket for pensjon-analyse-bq state
module "google_storage_bucket_dbt_state" {
  source = "../modules/google-cloud-storage"

  name                        = "pensjon-analyse-bq-state"
  location                    = var.gcp_project["region"]
  versioning                  = false
  principals                  = [module.google_bigquery_workload_pool.workpool-sa-email]
  uniform_bucket_level_access = true
}
