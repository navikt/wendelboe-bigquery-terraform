resource "google_service_account" "bigquery_airflow_dvh" {
  account_id   = "bigquery-airflow-dvh"
  display_name = "bigquery-airflow-dvh"
  project      = var.gcp_project["project"]
}

resource "google_project_iam_member" "bigquery_airflow_dvh_bq_user" {
  project = var.gcp_project["project"]
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.bigquery_airflow_dvh.email}"
}

# Gir nada airflow-bruker mulighet til å impersonere bigquery-airflow-dvh for å skrive data til BigQuery  
resource "google_service_account_iam_member" "bigquery_airflow_dvh_token_creator" {
  service_account_id = google_service_account.bigquery_airflow_dvh.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:pensjon-saksbehandling-nh4b@knada-gcp.iam.gserviceaccount.com"
}
