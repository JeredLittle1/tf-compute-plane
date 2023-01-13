variable "ip_address" { type = string }
variable "tls_secret_name" { type = string }
variable "domain_name" { type = string }

resource "helm_release" "nginx_ingress" {
  name          = "ingress-nginx"
  repository    = "https://kubernetes.github.io/ingress-nginx"
  chart         = "ingress-nginx"
  force_update  = true
  namespace     = "ingress-nginx"
  recreate_pods = true
  reuse_values  = true
  create_namespace = true

  values = [<<EOF
    controller:
      admissionWebhooks:
        enabled: false
      autoscaling:
        enabled: true
        minReplicas: 1
        maxReplicas: 2
        targetCPUUtilizationPercentage: 75
        targetMemoryUtilizationPercentage: 75
      config:
        use-forwarded-headers: "true"
      publishService:
        enabled: "true"
      resources:
        limits:
          cpu: 200m
          memory: 128Mi
        requests:
          cpu: 100m
          memory: 64Mi
      service:
        type: ClusterIP
        annotations:
          # service.beta.kubernetes.io/external-traffic: OnlyLocal
          beta.cloud.google.com/backend-config: '{"default": "iap-config"}'
          cloud.google.com/neg: '{"exposed_ports": {"80":{"name": "ingress-nginx-80-neg"}}}'
        # externalTrafficPolicy: "Local"
    defaultBackend:
      service:
        annotations:
          kubernetes.io/ingress.class: "nginx"
          nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
          nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
          nginx.ingress.kubernetes.io/ssl-redirect: "true"
    EOF
  ]
}

resource "kubectl_manifest" "argocd_ingress" {
  depends_on = [
    helm_release.nginx_ingress
  ]
  yaml_body = yamlencode({
    "apiVersion" : "networking.k8s.io/v1",
    "kind" : "Ingress",
    "metadata" : {
      "name" : "ingress-nginx",
      "namespace" : "ingress-nginx",
      "annotations" : {
        "ingress.kubernetes.io/rewrite-target" : "/",
        # Note: You can change the "regional" flag to "global" if using a global static IP.
        # "kubernetes.io/ingress.regional-static-ip-name" : var.ip_address,
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
      # "ingressClassName" : "nginx",
      "rules" : [
        {
          "host" : "compute-plane.${var.domain_name}",
          "http" : {
            "paths" : [
              {
                "path" : "/",
                "pathType" : "Prefix",
                "backend" : {
                  "service" : {
                    "name" : "ingress-nginx-controller",
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