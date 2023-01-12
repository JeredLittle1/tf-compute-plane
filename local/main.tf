variable "argocd_version" { type = string }
variable "domain_name" { type = string }
variable "sealed_secrets_tls_cert_path" { type = string }
variable "sealed_secrets_tls_key_path" { type = string }
variable "sealed_secrets_secret_id" { type = string }
variable "metric_server_revision" { type = string }
variable "argocd_admin_password" { type = string }

module "secrets" {
    source = "../modules/secrets"
    sealed_secret_id = var.sealed_secrets_secret_id
    tls_cert_value = base64encode(file(var.sealed_secrets_tls_cert_path))
    tls_key_value = base64encode(file(var.sealed_secrets_tls_key_path))
}

module "argocd" {
    source = "../modules/argocd"
    domain_name = var.domain_name
    argocd_version = var.argocd_version
    depends_on = [
      module.secrets
    ]
    admin_password = var.argocd_admin_password
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