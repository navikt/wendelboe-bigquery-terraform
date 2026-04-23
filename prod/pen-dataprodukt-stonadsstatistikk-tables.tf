resource "google_bigquery_table" "stonadsstatistikk_alder_belop" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "stonadsstatistikk_alder_belop"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/stonadsstatistikk_alder_belop.json")

}

resource "google_bigquery_table" "stonadsstatistikk_alder_beregning" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "stonadsstatistikk_alder_beregning"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/stonadsstatistikk_alder_beregning.json")

}

resource "google_bigquery_table" "stonadsstatistikk_alder_vedtak" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "stonadsstatistikk_alder_vedtak"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/stonadsstatistikk_alder_vedtak.json")

}

resource "google_bigquery_dataset_access" "pen_dataprodukt_stonadsstatistikk_alder_belop_view_access" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project    = var.gcp_project["project"]
  view {
    dataset_id = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
    project_id = var.gcp_project["project"]
    table_id   = module.stonadsstatistikk_alder_belop_til_team_pensjon_dvh_view.bigquery_view_id
  }

  depends_on = [module.stonadsstatistikk_alder_belop_til_team_pensjon_dvh_view]
}

resource "google_bigquery_dataset_access" "pen_dataprodukt_stonadsstatistikk_alder_beregning_view_access" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project    = var.gcp_project["project"]
  view {
    dataset_id = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
    project_id = var.gcp_project["project"]
    table_id   = module.stonadsstatistikk_alder_beregning_til_team_pensjon_dvh_view.bigquery_view_id
  }

  depends_on = [module.stonadsstatistikk_alder_beregning_til_team_pensjon_dvh_view]
}

resource "google_bigquery_dataset_access" "pen_dataprodukt_stonadsstatistikk_alder_vedtak_view_access" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  project    = var.gcp_project["project"]
  view {
    dataset_id = google_bigquery_dataset.stonadsstatistikk_til_team_pensjon_dvh_dataset.dataset_id
    project_id = var.gcp_project["project"]
    table_id   = module.stonadsstatistikk_alder_vedtak_til_team_pensjon_dvh_view.bigquery_view_id
  }

  depends_on = [module.stonadsstatistikk_alder_vedtak_til_team_pensjon_dvh_view]
}

resource "google_bigquery_table" "pen_ufore_diagnosekoder" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "pen_ufore_diagnosekoder"

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/pen_ufore_diagnosekoder.json")

}
