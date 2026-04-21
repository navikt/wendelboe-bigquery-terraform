resource "google_bigquery_dataset" "pen_dataprodukt_dataset" {
  dataset_id = "pen_dataprodukt_dataset"
  location   = var.gcp_project["region"]
  project    = var.gcp_project["project"]
  labels     = {}

  timeouts {}
}

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