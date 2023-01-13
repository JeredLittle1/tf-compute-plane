/*
module "ingress-nginx" {
  source = "../modules/ingress-nginx/"
  ip_address = resource.google_compute_global_address.nginx_static_ip.address
  tls_secret_name = var.tls_secret_name
  domain_name = var.domain_name
  depends_on = [
    resource.google_container_cluster.primary,
    resource.google_container_node_pool.general
  ]
  providers = {
    kubectl = kubectl
  }
}
*/

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
}

module "argo_master_app" {
  source          = "../modules/argo-master-app"
  app_name        = "argo-master-app"
  github_repo_url = var.argo_master_app_repo_url
  namespace       = var.compute_plane_namespace
  depends_on = [
    module.argocd
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
