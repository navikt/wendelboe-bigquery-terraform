resource "google_bigquery_dataset" "pen_dataprodukt_dataset" {
  dataset_id = "pen_dataprodukt_dataset"
  location   = var.gcp_project["region"]
  project    = var.gcp_project["project"]
  labels     = {}

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


resource "google_bigquery_table" "saksbehandlingsstatistikk_ufore" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "saksbehandlingsstatistikk_ufore"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/saksbehandlingsstatistikk.json")

}

resource "google_bigquery_table" "saksbehandlingsstatistikk_alder" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "saksbehandlingsstatistikk_alder"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/saksbehandlingsstatistikk.json")

}

resource "google_bigquery_dataset_access" "pen_dataprodukt_ufore_view_access" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project    = var.gcp_project["project"]
  view {
    dataset_id = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
    project_id = var.gcp_project["project"]
    table_id   = module.saksbehandlingsstatistikk_ufore_til_team_sak_view.bigquery_view_id
  }

  depends_on = [module.saksbehandlingsstatistikk_ufore_til_team_sak_view]
}

resource "google_bigquery_dataset_access" "pen_dataprodukt_alder_view_access" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project    = var.gcp_project["project"]
  view {
    dataset_id = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
    project_id = var.gcp_project["project"]
    table_id   = module.saksbehandlingsstatistikk_alder_til_team_sak_view.bigquery_view_id
  }

  depends_on = [module.saksbehandlingsstatistikk_alder_til_team_sak_view]
}