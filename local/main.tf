module "secrets" {
  source           = "../modules/secrets"
  sealed_secret_id = var.sealed_secrets_secret_id
  tls_cert_value   = base64encode(file(var.sealed_secrets_tls_cert_path))
  tls_key_value    = base64encode(file(var.sealed_secrets_tls_key_path))
  namespace        = var.compute_plane_namespace
  providers = {
    kubectl = kubectl
  }
  depends_on = [
    module.argocd
  ]
}
module "argocd" {
  source         = "../modules/argocd"
  argocd_version = var.argocd_version
  admin_password = var.argocd_admin_password
  namespace      = var.compute_plane_namespace
  service_type = "NodePort"
  providers = {
    kubectl = kubectl
  }
}

# Create metrics server which isn't included by default for local development. Helpful for memory/cpu analysis.
/*
resource "helm_release" "metrics" {
  name = "metrics-server"

  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  version          = "3.8.3"
  create_namespace = true
  values = [
    yamlencode(
      {
        "args" : ["--kubelet-insecure-tls"]
      }
    )
  ]
}
*/