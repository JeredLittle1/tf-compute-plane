variable "argocd_version" { type = string }
variable "google_client_id" { type = string }
variable "google_secret_id" { type = string }
variable "enable_google_auth" { type = bool }
variable "default_role" { type = string }
variable "rbac_scopes" { type = string }
variable "admin_password" { 
  type = string 
  sensitive = true
}
variable "domain_name" { type = string }
variable "sealed_secrets_tls_cert_path" { type = string }
variable "sealed_secrets_tls_key_path" { type = string }
variable "sealed_secrets_secret_id" { type = string }
variable "sso_secret_id" { type = string }
variable "metric_server_revision" { type = string }
variable "sso_namespaces" { type = list }

module "secrets" {
    source = "../modules/secrets"
    sealed_secret_id = var.sealed_secrets_secret_id
    tls_cert_value = base64encode(file(var.sealed_secrets_tls_cert_path))
    tls_key_value = base64encode(file(var.sealed_secrets_tls_key_path))
    sso_secret_id = var.sso_secret_id
    sso_config_secret_map = {
      "client-id" : base64encode(var.google_client_id),
      "client-secret" : base64encode(var.google_secret_id)
    }
    sso_namespaces = var.sso_namespaces
}

module "argocd" {
    source = "../modules/argocd"
    admin_password = var.admin_password
    rbac_scopes = var.rbac_scopes
    default_role = var.default_role
    domain_name = var.domain_name
    enable_google_auth = var.enable_google_auth
    google_secret_id = var.google_secret_id
    google_client_id = var.google_client_id
    argocd_version = var.argocd_version
    depends_on = [
      module.secrets
    ]
}

module "argo_master_app" {
    source = "../modules/argo-master-app"
    app_name = "argo-master-app"
    github_repo_url = "https://github.com/JeredLittle1/team-engineering.git"
    depends_on = [
      module.argocd
    ]
}


# Create metrics server which isn't included by default for local development. Helpful for memory/cpu analysis.
resource "helm_release" "metrics" {
  name = "metrics-server"

  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  version          = var.metric_server_revision
  create_namespace = true
  values = [
    yamlencode(
      {
        "args" : ["--kubelet-insecure-tls"]
      }
    )
  ]
}