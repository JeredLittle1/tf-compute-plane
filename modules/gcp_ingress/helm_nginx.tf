variable "ip_address" { type = string }
variable "tls_secret_name" { type = string }
variable "domain_name" { type = string }
variable "namespace" { type = string }


resource "kubectl_manifest" "ingress" {
  yaml_body = yamlencode({
    "apiVersion" : "networking.k8s.io/v1",
    "kind" : "Ingress",
    "metadata" : {
      "name" : "compute-plane-ingress",
      "namespace" : var.namespace,
      "annotations" : {
        # "ingress.kubernetes.io/rewrite-target" : "/",
        # Note: Make sure below is a GLOBAL IP address in GCP! Not REGIONAL!
        # "kubernetes.io/ingress.global-static-ip-name" : var.ip_address,
        # Use the two below settings if creating a managed cert with GCP: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs
        # "networking.gke.io/managed-certificates" : "managed-cert",
        # "kubernetes.io/ingress.class" : "gce"
      }
    },
    "spec" : {
      # Used for a custom TLS cert NOT managed by Google.
      "tls": var.tls_secret_name != null ? [
        {
          "secretName": var.tls_secret_name
        }
      ] : [], 
      "rules" : [
        {
          "host" : "compute-plane.${var.domain_name}",
          "http" : {
            "paths" : [
              {
                "path" : "/cd",
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