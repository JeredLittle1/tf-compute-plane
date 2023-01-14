# Use: Bootstraps ArgoCD to the cluster and sealed-secrets.

module "argocd" {
  source         = "../modules/argocd"
  domain_name    = var.domain_name
  argocd_version = var.argocd_version
  admin_password = var.argocd_admin_password
  namespace      = var.compute_plane_namespace
  providers = {
    kubectl = kubectl
  }
  tls_secret_name = "iap-tls"
  depends_on = [
    resource.google_container_cluster.primary,
    resource.google_container_node_pool.general
  ]
}
module "secrets" {
  source           = "../modules/secrets"
  sealed_secret_id = var.sealed_secrets_secret_id
  tls_cert_value   = base64encode(file(var.sealed_secrets_tls_cert_path))
  tls_key_value    = base64encode(file(var.sealed_secrets_tls_key_path))
  namespace        = var.compute_plane_namespace
  providers = {
    kubectl = kubectl
  }
}