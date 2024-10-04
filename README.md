# code-challenge

This repo contains the Terraform to create a VPC, subnet, GKE cluster with 2 nodes and autoscaling enabled. It uses GCS for it's backend remote-state leveraging [code-challenge-tfstate](https://github.com/2ffs2nns/code-challenge-tfstate]) It is expected that a new bucket will be created prior to deploying this Terraform configuration.

GCS buckets support native locking. If the `wrapper.py` is run twice in parallel a locking error will occur. ie

```bash
Error: Error acquiring the state lock

Error message: writing "gs://code-challenge-62079-tfstate/terraform/development/gke-code-challenge/default.tflock" failed: googleapi: Error 412: At least one of the pre-conditions you specified did not hold., conditionNotMet
Lock Info:
   ID:        1234567890123456
   Path:      gs://code-challenge-62079-tfstate/terraform/development/gke-code-challenge/default.tflock
   Operation: OperationTypeApply
   Who:       ehoffmann@Erics-MacBook-Air.local
   Version:   1.9.5
   Created:   2024-10-03 19:02:30.730822 +0000 UTC
```

>NOTE: It is required to create a new GCS bucket and manually modify `backend.tf` with your unique GCS bucket to run this code-challenge.

## Monitoring & Alerts

Monitoring, logging and alerting is enabled with three custom metrics

* GKE Container - High CPU Limit Utilization
* GKE Container - High Memory Limit Utilization
* GKE Container - Restarts

>NOTE: Please modify the default `custom_metrics_email` variable.

## Python Wrapper script

There is a `wrapper.py` script to manage the deployment of this Terraform. It allows customization of the deployment by supporting different tfvars files and the backend.

```bash
    Usage: python wrapper.py <action>
     --var_file=<path_to_var_file>
     --gcloud_env=<gcloud_env>
     --project_name=<project_name> [--working_dir=<working_directory>]

    Available actions: init, apply, plan, destroy
    With the init action, the combination of <gcloud_env> and <project_name> set the GCS backend_config. ie
    terraform init -backend-config='prefix=terraform/<gcloud_env>/<project_name>/'
```

The thinking with the `gcloud_env` parameter is to support different environments/projects ie `production | staging | development`.

>NOTE: You must install the required dependencies with `pip install -r requirements.txt`

To deploy, run the following commands.

```bash
python wrapper.py init --var_file=development.tfvars --gcloud_env=development --project_name=code-challenge-tfstate

python wrapper.py plan --var_file=development.tfvars --gcloud_env=development --project_name=code-challenge-tfstate

python wrapper.py apply --var_file=development.tfvars --gcloud_env=development --project_name=code-challenge-tfstate
```

>NOTE: Be sure to modify/change the default project_id and region in `development.tfvars` to your specific values. Also, update the bucket in `backend.tf`

## Best Practices

Git-actions are setup to run against all pull-requests covering `tflint`, `tf-fmt`, `checkov` and `bandit`. Checkov and Bandit are SAST security tools for Terraform and Python. There is also a `pre-commit` hook setup to auto-generate Terraform docs using `terraform-docs`. Although it is not automated with a hook or action, I also used `inkdrop` to visualize a diagram of this project/configuration.

<!-- BEGIN_TF_DOCS -->
# Terraform

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_max_node_count"></a> [autoscaling\_max\_node\_count](#input\_autoscaling\_max\_node\_count) | Max number of nodes to scale up to | `number` | `2` | no |
| <a name="input_custom_metrics_email"></a> [custom\_metrics\_email](#input\_custom\_metrics\_email) | Email to receive custom metric alerts | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Prevent terraform from nuking the cluster if true | `bool` | `true` | no |
| <a name="input_gcloud_env"></a> [gcloud\_env](#input\_gcloud\_env) | Environment to deploy into. ie production, staging, development | `string` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | GKE cluster name | `string` | n/a | yes |
| <a name="input_guest_accelerator_count"></a> [guest\_accelerator\_count](#input\_guest\_accelerator\_count) | Guest accelerator count. | `string` | `2` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Default machine\_type | `string` | `"e2-micro"` | no |
| <a name="input_node_pool_disk_size_gb"></a> [node\_pool\_disk\_size\_gb](#input\_node\_pool\_disk\_size\_gb) | Default disk size for nodes. | `string` | `"50"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Default gcloud project to launch this cluster into | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name, typically the git repository | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for subnets | `string` | `"us-central1"` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | Set the release channel, RAPID, REGULAR, STABLE | `string` | `"REGULAR"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | gcloud service account name to use. | `string` | `"terraform"` | no |
| <a name="input_skip_service_account_creation"></a> [skip\_service\_account\_creation](#input\_skip\_service\_account\_creation) | Ignore creating new service account if the name already exists. | `bool` | `true` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Primary project\_id subnet cidr range | `string` | `"10.0.0.0/16"` | no |
| <a name="input_use_guest_accelerator"></a> [use\_guest\_accelerator](#input\_use\_guest\_accelerator) | Use guest accelerator | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Root certificate of the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Cluster Endpoint |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Cluster Name |
| <a name="output_container_admin_iam_member_role"></a> [container\_admin\_iam\_member\_role](#output\_container\_admin\_iam\_member\_role) | n/a |
| <a name="output_logging_dashboard_url"></a> [logging\_dashboard\_url](#output\_logging\_dashboard\_url) | n/a |
| <a name="output_monitoring_dashboard_url"></a> [monitoring\_dashboard\_url](#output\_monitoring\_dashboard\_url) | n/a |
| <a name="output_network_admin_iam_member_role"></a> [network\_admin\_iam\_member\_role](#output\_network\_admin\_iam\_member\_role) | n/a |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | n/a |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | n/a |
| <a name="output_node_pool_id"></a> [node\_pool\_id](#output\_node\_pool\_id) | Node pool Id |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | n/a |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | n/a |
| <a name="output_subnetwork_ip_range"></a> [subnetwork\_ip\_range](#output\_subnetwork\_ip\_range) | n/a |
| <a name="output_subnetwork_name"></a> [subnetwork\_name](#output\_subnetwork\_name) | n/a |
| <a name="output_subnetwork_region"></a> [subnetwork\_region](#output\_subnetwork\_region) | n/a |
| <a name="output_subnetwork_self_link"></a> [subnetwork\_self\_link](#output\_subnetwork\_self\_link) | n/a |
<!-- END_TF_DOCS -->

## Diagram

<div align=center>
<img src="diagram.svg" alt="diagram" width="300"/>
</div>
