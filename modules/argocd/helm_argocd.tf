variable "argocd_version" { type = string }
variable "domain_name" { type = string }
variable "admin_password" { type = string }

locals {
  dex_config = {
    "dex.config" : <<EOF
      connectors:
        - type: authproxy
          id: iap_proxy
          name: "Google IAP"
          config:
            userHeader: "X-Goog-Authenticated-User-Email"
    EOF
  }
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
          "extraArgs" : ["--insecure"],
          /*
          "service": {
            "type" : "LoadBalancer",
            "annotations" : {
              "beta.cloud.google.com/backend-config" : "{\"default\": \"iap-config\"}",
            }
          }
          */
        },
        "configs" : {
          "cm" : merge(
            {
              "url" : "http://argocd.${var.domain_name}"
            },
            local.dex_config != {} ? local.dex_config : {}
          ),
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
/*
resource "kubernetes_manifest" "argocd_ingress" {
  manifest = {
    "apiVersion" : "networking.k8s.io/v1",
    "kind" : "Ingress",
    "metadata" : {
      "name" : "ingress-argocd",
      "namespace" : "argocd",
      "annotations" : {
        "ingress.kubernetes.io/rewrite-target" : "/"
      }
    },
    "spec" : {
      "rules" : [
        {
          "host" : "argocd.${var.domain_name}",
          "http" : {
            "paths" : [
              {
                "path" : "/",
                "pathType" : "Prefix",
                "backend" : {
                  "service" : {
                    "name" : "argocd-server",
                    "port" : {
                      "number" : 80
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
}
*/