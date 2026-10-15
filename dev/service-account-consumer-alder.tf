resource "google_project_iam_member" "consumer_alder_bigquery_data_editor" {
  project = var.gcp_project["project"]
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:consumer-alder@dv-team-pensjon-dev-9a2c.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "consumer_alder_bigquery_user" {
  project = var.gcp_project["project"]
  role    = "roles/bigquery.user"
  member  = "serviceAccount:consumer-alder@dv-team-pensjon-dev-9a2c.iam.gserviceaccount.com"
}
