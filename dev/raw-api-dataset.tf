# 1. Create the separate raw dataset
resource "google_bigquery_dataset" "raw_api_dataset" {
  dataset_id    = "raw_api_data"
  friendly_name = "Raw API Storage"
  description   = "Rådata fra apier"
  location      = var.gcp_project["region"]
  project       = var.gcp_project["project"]
  labels        = {}

  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }

  access {
    role          = "READER"
    special_group = "projectReaders"
  }

  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }

  access {
    role          = "WRITER"
    user_by_email = google_service_account.bigquery_airflow_dvh.email
  }

  timeouts {}
}

# 2. Create the table with a minimal, flexible schema
resource "google_bigquery_table" "raw_norg2_intern_nav_table" {
  dataset_id  = google_bigquery_dataset.raw_api_dataset.dataset_id
  table_id    = "norg2_intern_nav"
  description = "https://norg2.intern.nav.no/norg2/api/v1/enhet"

  schema = <<EOF
[
  {
    "name": "extracted_at",
    "type": "TIMESTAMP",
    "mode": "REQUIRED",
    "description": "The time the Python script fetched the data",
    "defaultValueExpression": "CURRENT_TIMESTAMP()"
  },
  {
    "name": "raw_json_payload",
    "type": "JSON",
    "mode": "REQUIRED",
    "description": "The unaltered JSON payload from the API"
  }
]
EOF
}