variable "project_name" {
  description = "Project name, typically the git repository"
  type        = string
}

variable "gcloud_env" {
  description = "Environment to deploy into. ie production, staging, development"
  type        = string
}

variable "project_id" {
  description = "Default gcloud project to launch this cluster into"
  type        = string
}

variable "region" {
  default     = "us-central1"
  description = "Region for subnets"
  type        = string
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "release_channel" {
  default     = "REGULAR"
  description = "Set the release channel, RAPID, REGULAR, STABLE"
  type        = string
}

variable "autoscaling_max_node_count" {
  default     = 2
  description = "Max number of nodes to scale up to"
  type        = number
}

variable "machine_type" {
  default     = "e2-micro"
  description = "Default machine_type"
  type        = string
}

variable "node_pool_disk_size_gb" {
  default     = "50"
  description = "Default disk size for nodes."
  type        = string
}
variable "use_guest_accelerator" {
  default     = false
  description = "Use guest accelerator"
  type        = bool
}

variable "guest_accelerator_count" {
  default     = 2
  description = "Guest accelerator count."
  type        = string
}

variable "subnet" {
  default     = "10.0.0.0/16"
  description = "Primary project_id subnet cidr range"
  type        = string
}

variable "deletion_protection" {
  default     = true
  description = "Prevent terraform from nuking the cluster if true"
  type        = bool
}

variable "service_account_name" {
  default     = "terraform"
  description = "gcloud service account name to use."
  type        = string
}

variable "skip_service_account_creation" {
  default     = true
  description = "Ignore creating new service account if the name already exists."
  type        = bool
}

variable "custom_metrics_email" {
  description = "Email to receive custom metric alerts"
  type        = string
}
