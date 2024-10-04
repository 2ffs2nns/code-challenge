resource "google_compute_network" "vpc" {
  #checkov:skip=CKV2_GCP_18:Ensure GCP network defines a firewall and does not use the default firewall
  name                    = "${var.project_id}-vpc"
  description             = "${var.project_name}/${var.gcloud_env}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.project_id}-subnet"
  description              = "${var.project_name}/${var.gcloud_env}"
  region                   = var.region
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = var.subnet
  private_ip_google_access = true

  log_config {
    flow_sampling = "0.5"
  }
}
