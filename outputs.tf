# iam

output "service_account_email" {
  value = google_service_account.terraform.email
}

output "service_account_id" {
  value = google_service_account.terraform.id
}

output "container_admin_iam_member_role" {
  value = google_project_iam_member.container_admin.role
}

output "network_admin_iam_member_role" {
  value = google_project_iam_member.network_admin.role
}

# vpc

output "network_name" {
  value = google_compute_network.vpc.name
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "subnetwork_name" {
  value = google_compute_subnetwork.subnet.name
}

output "subnetwork_ip_range" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}

output "subnetwork_region" {
  value = google_compute_subnetwork.subnet.region
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}

# gke

output "cluster_id" {
  description = "Cluster ID"
  value       = google_container_cluster.primary.id
}

output "cluster_name" {
  description = "Cluster Name"
  value       = google_container_cluster.primary.name
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.pool
  ]
}

output "cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "Root certificate of the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

# node_pool

output "node_pool_id" {
  description = "Node pool Id"
  value       = google_container_node_pool.pool.id
}

output "monitoring_dashboard_url" {
  value = "https://console.cloud.google.com/monitoring?project=${var.project_id}"
}

output "logging_dashboard_url" {
  value = "https://console.cloud.google.com/logs?project=${var.project_id}"
}
