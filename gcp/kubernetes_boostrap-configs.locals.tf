locals {
  ingress_rules = [
    {
      "host" : "cd.${var.domain_name}",
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
    },
    {
      "host" : "airflow.${var.domain_name}",
      "http" : {
        "paths" : [
          {
            "path" : "/",
            "pathType" : "Prefix",
            "backend" : {
              "service" : {
                "name" : "airflow-webserver",
                "port" : {
                  "name" : "airflow-ui"
                }
              }
            }
          }
        ]
      }
    },
    {
      "host" : "monitoring.${var.domain_name}",
      "http" : {
        "paths" : [
          {
            "path" : "/",
            "pathType" : "Prefix",
            "backend" : {
              "service" : {
                "name" : "kube-prometheus-stack-grafana",
                "port" : {
                  "name" : "http-web"
                }
              }
            }
          }
        ]
      }
    },
    {
      "host" : "workflows.${var.domain_name}",
      "http" : {
        "paths" : [
          {
            "path" : "/",
            "pathType" : "Prefix",
            "backend" : {
              "service" : {
                "name" : "argo-workflows-server",
                "port" : {
                  "number" : 2746
                }
              }
            }
          }
        ]
      }
    },
    {
      "host" : "notebooks.${var.domain_name}",
      "http" : {
        "paths" : [
          {
            "path" : "/",
            "pathType" : "Prefix",
            "backend" : {
              "service" : {
                "name" : "proxy-public",
                "port" : {
                  "number" : 80
                }
              }
            }
          }
        ]
      }
    },    
    {
      "host" : "airbyte.${var.domain_name}",
      "http" : {
        "paths" : [
          {
            "path" : "/",
            "pathType" : "Prefix",
            "backend" : {
              "service" : {
                "name" : "airbyte-airbyte-webapp-svc",
                "port" : {
                  "number" : 80
                }
              }
            }
          }
        ]
      }
    },
  ]
  # Use the two below settings if creating a managed cert with GCP: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs
  managed_cert_annotations = var.use_google_managed_cert ? {
    "networking.gke.io/managed-certificates" : "managed-cert",
    "kubernetes.io/ingress.class" : "gce"
  } : {}
}
