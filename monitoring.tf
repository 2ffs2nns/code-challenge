resource "google_project_service" "monitoring_api" {
  project                    = var.project_id
  service                    = "monitoring.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
}

resource "google_project_service" "logging_api" {
  project                    = var.project_id
  service                    = "logging.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
}

resource "google_project_service" "container_api" {
  project                    = var.project_id
  service                    = "container.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
}
