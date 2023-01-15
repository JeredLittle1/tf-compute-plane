variable "argocd_version" { type = string }
variable "admin_password" { type = string }
variable "namespace" { type = string }
variable "service_type" {
  type = string
  default = "ClusterIP"
}


resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  version          = var.argocd_version
  create_namespace = true
  values = [
    yamlencode(
      {
        "dex" : {
          "enabled" : false
        },
        "server" : {
          "extraArgs" : ["--insecure"],
          "service": {
            "type" : var.service_type,
            "annotations" : {
              "beta.cloud.google.com/backend-config" : "{\"default\": \"iap-config\"}",
            }
          }
        },
        "configs" : {
          "params" : {
              "server.disable.auth" : true
            },
          "rbac" : {
            "create" : false
          },
          "secret" : {
            "argocdServerAdminPassword" : bcrypt(var.admin_password)
          }
        }
      }
    )
  ]
}