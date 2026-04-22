resource "google_bigquery_dataset" "pen_dataprodukt_dataset" {
  dataset_id = "pen_dataprodukt_dataset"
  location   = var.gcp_project["region"]
  project    = var.gcp_project["project"]
  labels     = {}

  timeouts {}
}

# Tilgang - Settes utenfor dataset modulen
resource "google_bigquery_dataset_access" "pen_dataprodukt_dataset_owners" {
  dataset_id    = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project       = var.gcp_project["project"]
  role          = "OWNER"
  special_group = "projectOwners"
}

resource "google_bigquery_dataset_access" "pen_dataprodukt_dataset_readers" {
  dataset_id    = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project       = var.gcp_project["project"]
  role          = "READER"
  special_group = "projectReaders"
}

resource "google_bigquery_dataset_access" "pen_dataprodukt_dataset_writers" {
  dataset_id    = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project       = var.gcp_project["project"]
  role          = "WRITER"
  special_group = "projectWriters"
}

resource "google_bigquery_dataset_access" "pen_dataprodukt_dataset_airflow_dvh" {
  dataset_id    = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project       = var.gcp_project["project"]
  role          = "WRITER"
  user_by_email = google_service_account.bigquery_airflow_dvh.email
}
