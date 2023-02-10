variable "nodetype" {
  description = "type of nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "argocd_version" {
  description = "Version for ArgoCD"
  type        = string
  default     = "5.16.13"
}

variable "argocd_admin_password" {
  description = "Admin PW for ArgoCD"
  type        = string
  sensitive   = true
}

variable "compute_plane_namespace" {
  type        = string
  description = "The namespace where the main compute plane resources live."
  default     = "compute-plane"
}

variable "team_repo_url" {
  type        = string
  description = "The Github repo URL which hosts the Argo applications"
  default     = "https://github.com/JeredLittle1/team-engineering.git"
}

variable "sealed_secrets_secret_id" {
  type        = string
  description = "The secret ID to bootstrap the certs for sealed secrets to"
  default     = "sealed-secrets-tls"
}

variable "sealed_secrets_tls_cert_path" {
  type        = string
  description = "The TLS cert path for sealed secrets locally."
  # default     = "~/.sealed-secrets/certs/mytls.crt"
}
variable "sealed_secrets_tls_key_path" {
  type        = string
  description = "The TLS key path for sealed secrets locally."
  # default     = "~/.sealed-secrets/certs/mytls.key"
}

variable "argo_master_app_github_repo" {
  type        = string
  description = "The github repo hosting the argo master apps"
  default     = "https://github.com/JeredLittle1/argo-master-app"
}

variable "argo_master_app_repo_branch" {
  type        = string
  description = "The branch to use for the argo master app repo"
  default     = "master"
}

variable "airflow_image" {
  type        = string
  description = "The docker image url to use for Airflow"
  default     = "gcr.io/gcp-test-jlittle/custom-airflow-2.5.0"
}

variable "team_repo_branch" {
  type        = string
  description = "The branch in the team's repo to use for Airflow DAGs/apps/secrets."
  default     = "master"
}