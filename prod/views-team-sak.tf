resource "google_bigquery_dataset" "saksbehandlingsstatistikk_til_team_sak_dataset" {
  dataset_id    = "saksbehandlingsstatistikk_til_team_sak_dataset"
  location      = var.gcp_project["region"]
  friendly_name = "saksbehandlingsstatistikk_til_team_sak_dataset"
  labels        = {}
  description   = "Datagrunnlag tiltenkt delt med Team Sak for saksbehandlingsstatistikk. Basert på hendelser fra pen_dataprodukt skjemaet i pen-databasen"

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
    role          = "READER"
    user_by_email = "uforetrygd-ptsak-reader@ptsak-prod-1ff7.iam.gserviceaccount.com"
  }
  timeouts {}
}


module "saksbehandlingsstatistikk_ufore_til_team_sak_view" {
  source              = "../modules/google-bigquery-view"
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
  view_id             = "saksbehandlingsstatistikk_ufore_view"
  view_description    = "Basert på en rekke hendelser fra pen_dataprodukt skjemaet i pen-databasen"
  view_schema         = file("${path.module}/../schemas/saksbehandlingsstatistikk.json")
  view_query          = <<EOF
SELECT
  *
FROM
  `${var.gcp_project["project"]}.${google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id}.saksbehandlingsstatistikk_ufore`
EOF
}



resource "google_bigquery_table_iam_binding" "behandlingshendelse_view_iam_binding" {
  project    = var.gcp_project.project
  dataset_id = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
  table_id   = module.saksbehandlingsstatistikk_ufore_til_team_sak_view.bigquery_view_id
  role       = "roles/bigquery.dataViewer"
  members    = ["serviceAccount:uforetrygd-ptsak-reader@ptsak-prod-1ff7.iam.gserviceaccount.com"]
}


module "saksbehandlingsstatistikk_alder_til_team_sak_view" {
  source              = "../modules/google-bigquery-view"
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
  view_id             = "saksbehandlingsstatistikk_alder_view"
  view_description    = "Basert på en rekke hendelser fra pen_dataprodukt skjemaet i pen-databasen"
  view_schema         = file("${path.module}/../schemas/saksbehandlingsstatistikk.json")
  view_query          = <<EOF
SELECT
  *
FROM
  `${var.gcp_project["project"]}.${google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id}.saksbehandlingsstatistikk_alder`
EOF
}


resource "google_bigquery_table_iam_binding" "behandlingshendelse_alder_view_iam_binding" {
  project    = var.gcp_project.project
  dataset_id = google_bigquery_dataset.saksbehandlingsstatistikk_til_team_sak_dataset.dataset_id
  table_id   = module.saksbehandlingsstatistikk_alder_til_team_sak_view.bigquery_view_id
  role       = "roles/bigquery.dataViewer"
  members    = ["serviceAccount:uforetrygd-ptsak-reader@ptsak-prod-1ff7.iam.gserviceaccount.com"]
}
