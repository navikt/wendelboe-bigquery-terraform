resource "google_bigquery_dataset" "stonadsstatistikk_til_team_pensjon_dvh_dataset" {
  dataset_id    = "stonadsstatistikk_til_team_pensjon_dvh_dataset"
  location      = var.gcp_project["region"]
  friendly_name = "stonadsstatistikk_til_team_pensjon_dvh_dataset"
  labels        = {}
  description   = "Datagrunnlag tiltenkt delt med team Pensjon DVH for stønadstatistikk. Basert på hendelser fra pen_dataprodukt skjemaet i pen-databasen"

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
    user_by_email = "consumer-alder@dv-team-pensjon-prod-fb4a.iam.gserviceaccount.com"
  }
  timeouts {}
}


module "stonadsstatistikk_alder_belop_til_team_pensjon_dvh_view" {
  source              = "../modules/google-bigquery-view"
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
  view_id             = "stonadsstatistikk_alder_belop_view"
  view_description    = "Basert på en rekke hendelser fra pen_dataprodukt skjemaet i pen-databasen"
  view_schema         = file("${path.module}/../schemas/stonadsstatistikk_alder_belop.json")
  view_query          = <<EOF
SELECT
  *
FROM
  `${var.gcp_project["project"]}.${google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id}.stonadsstatistikk_alder_belop`
EOF
}

resource "google_bigquery_table_iam_binding" "stonadsstatistikk_alder_belop_view_iam_binding" {
  project    = var.gcp_project.project
  dataset_id = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
  table_id   = module.stonadsstatistikk_alder_belop_til_team_pensjon_dvh_view.bigquery_view_id
  role       = "roles/bigquery.dataViewer"
  members    = ["serviceAccount:consumer-alder@dv-team-pensjon-prod-fb4a.iam.gserviceaccount.com"]
}


module "stonadsstatistikk_alder_beregning_til_team_pensjon_dvh_view" {
  source              = "../modules/google-bigquery-view"
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
  view_id             = "stonadsstatistikk_alder_beregning_view"
  view_description    = "Basert på en rekke hendelser fra pen_dataprodukt skjemaet i pen-databasen"
  view_schema         = file("${path.module}/../schemas/stonadsstatistikk_alder_beregning.json")
  view_query          = <<EOF
SELECT
  *
FROM
  `${var.gcp_project["project"]}.${google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id}.stonadsstatistikk_alder_beregning`
EOF
}

resource "google_bigquery_table_iam_binding" "stonadsstatistikk_alder_beregning_view_iam_binding" {
  project    = var.gcp_project.project
  dataset_id = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
  table_id   = module.stonadsstatistikk_alder_beregning_til_team_pensjon_dvh_view.bigquery_view_id
  role       = "roles/bigquery.dataViewer"
  members    = ["serviceAccount:consumer-alder@dv-team-pensjon-prod-fb4a.iam.gserviceaccount.com"]
}


module "stonadsstatistikk_alder_vedtak_til_team_pensjon_dvh_view" {
  source              = "../modules/google-bigquery-view"
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
  view_id             = "stonadsstatistikk_alder_vedtak_view"
  view_description    = "Basert på en rekke hendelser fra pen_dataprodukt skjemaet i pen-databasen"
  view_schema         = file("${path.module}/../schemas/stonadsstatistikk_alder_vedtak.json")
  view_query          = <<EOF
SELECT
  *
FROM
  `${var.gcp_project["project"]}.${google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id}.stonadsstatistikk_alder_vedtak`
EOF
}

resource "google_bigquery_table_iam_binding" "stonadsstatistikk_alder_vedtak_view_iam_binding" {
  project    = var.gcp_project.project
  dataset_id = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
  table_id   = module.stonadsstatistikk_alder_vedtak_til_team_pensjon_dvh_view.bigquery_view_id
  role       = "roles/bigquery.dataViewer"
  members    = ["serviceAccount:consumer-alder@dv-team-pensjon-prod-fb4a.iam.gserviceaccount.com"]
}
