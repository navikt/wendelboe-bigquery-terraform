resource "google_bigquery_table" "styringscockpit_sak_ufore" {
  dataset_id = google_bigquery_dataset.pen_dataprodukt_dataset.dataset_id
  table_id   = "styringscockpit_sak_ufore"

  labels = {
    env = "default"
  }

  schema = file("${path.module}/../schemas/styringscockpit_sak_ufore.json")

}
