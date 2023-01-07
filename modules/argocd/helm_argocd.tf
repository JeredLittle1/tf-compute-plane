variable "argocd_version" { type = string }
variable "google_client_id" { type = string }
variable "google_secret_id" { type = string }
variable "enable_google_auth" { type = bool }
variable "domain_name" { type = string }
variable "default_role" { type = string }
variable "rbac_scopes" { type = string }
variable "admin_password" { type = string }

locals {
  dex_config = var.enable_google_auth ? {
    "dex.config" : <<EOF
      connectors:
      - config:
          issuer: https://accounts.google.com
          clientID: ${var.google_client_id}
          clientSecret: ${var.google_secret_id}
        type: oidc
        id: google
        name: Google
    EOF
  } : {}
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = var.argocd_version
  create_namespace = true
  values = [
    yamlencode(
      {
        "server" : {
          "extraArgs" : ["--insecure"]
        },
        "configs" : {
          "cm" : merge(
            {
              "url" :"http://argocd.${var.domain_name}"
            },
            local.dex_config != {} ? local.dex_config : {}
          ),
          "rbac" : {
                "create" : true,
                "policy.default" : var.default_role,
                "scopes" : var.rbac_scopes
          },
          "secret" : {
            "argocdServerAdminPassword" : bcrypt(var.admin_password)
          }
        }
      }
    )
  ]
}