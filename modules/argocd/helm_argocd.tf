variable "argocd_version" { type = string }
variable "domain_name" { type = string }
variable "admin_password" { type = string }
variable "tls_secret_name" { type = string }
variable "namespace" { type = string }

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
          "extraArgs" : ["--insecure", "--rootpath=/cd"],
          "service": {
            "annotations" : {
              "beta.cloud.google.com/backend-config" : "{\"default\": \"iap-config\"}",
            }
          }
        },
        "configs" : {
          /*"cm" : merge(
            /* {
              "url" : "https://argocd.${var.domain_name}"
            },*
            local.dex_config != {} ? local.dex_config : {},
          ),*/
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

/*
resource "kubectl_manifest" "argocd_ingress" {
  depends_on = [
    helm_release.argocd
  ]
  yaml_body = yamlencode({
    "apiVersion" : "networking.k8s.io/v1",
    "kind" : "Ingress",
    "metadata" : {
      "name" : "ingress-argocd",
      "namespace" : "argocd",
      "annotations" : {
        "ingress.kubernetes.io/rewrite-target" : "/",
        # "kubernetes.io/ingress.global-static-ip-name" : var.static_ip,
        # "networking.gke.io/managed-certificates" : "managed-cert",
        # "kubernetes.io/ingress.class" : "gce"
      }
    },
    "spec" : {
      
      "tls": var.tls_secret_name != null ? [
        {
          "secretName": var.tls_secret_name
        }
      ] : [], 
      # "ingressClassName" : "nginx",
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
  })
}
*/