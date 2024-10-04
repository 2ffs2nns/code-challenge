resource "google_container_node_pool" "pool" {
  #checkov:skip=CKV_GCP_69:Ensure the GKE Metadata Server is Enabled
  name     = google_container_cluster.primary.name
  cluster  = google_container_cluster.primary.name
  location = var.region

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    service_account = google_service_account.terraform.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    dynamic "guest_accelerator" {
      for_each = var.use_guest_accelerator ? [1] : []

      content {
        type  = var.gpu_type
        count = var.guest_accelerator_count

        gpu_driver_installation_config {
          gpu_driver_version = var.gpu_driver_version
        }
      }
    }

    machine_type = var.machine_type
    tags         = ["gke-node", var.project_id, var.gcloud_env]

    disk_size_gb = var.node_pool_disk_size_gb
    disk_type    = "pd-balanced"

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  timeouts {
    create = "20m"
    update = "30m"
  }

  autoscaling {
    total_min_node_count = 1
    total_max_node_count = var.autoscaling_max_node_count
  }
}
