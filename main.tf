resource "google_container_cluster" "primary" {
  #checkov:skip=CKV_GCP_13:Ensure client certificate authentication to Kubernetes Engine Clusters is disabled
  #checkov:skip=CKV_GCP_20:Ensure master authorized networks is set to enabled in GKE clusters
  #checkov:skip=CKV_GCP_23:Ensure Kubernetes Cluster is created with Alias IP ranges enabled
  #checkov:skip=CKV_GCP_65:Manage Kubernetes RBAC users with Google Groups for GKE
  #checkov:skip=CKV_GCP_66:Ensure use of Binary Authorization
  #checkov:skip=CKV_GCP_69:Ensure the GKE Metadata Server is Enabled
  name                     = var.gke_cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  resource_labels = {
    environment = var.gcloud_env
    project     = var.project_name
  }

  network_policy {
    enabled = true
  }

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  release_channel {
    channel = var.release_channel
  }

  enable_intranode_visibility = true
  deletion_protection         = var.deletion_protection
}
