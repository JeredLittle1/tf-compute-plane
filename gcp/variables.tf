locals {
  ingress_paths = [
    {
      "path" : "/cd",
      "pathType" : "Prefix", # Must be implementation specific or white page appears
      "backend" : {
        "service" : {
          "name" : "argocd-server",
          "port" : {
            "number" : 80
          }
        }
      }
    },
    {
      "path" : "/airflow",
      "pathType" : "Prefix", # Must be implementation specific or white page appears
      "backend" : {
        "service" : {
          "name" : "airflow-webserver",
          "port" : {
            "name" : "airflow-ui"
          }
        }
      }
    },
    {
      "path" : "/grafana",
      "pathType" : "Prefix", # Must be implementation specific or white page appears
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

variable "project" {
  description = "The project ID to host the cluster in"
  type        = string
  default     = "gcp-test-jlittle"
}

variable "name" {
  description = "name of the kubernetes cluster"
  type        = string
  default     = "primary"
}

variable "region" {
  description = "The project ID to host the cluster in"
  type        = string
  default     = "us-east1"
}


variable "location" {
  description = "location for k8s cluster"
  type        = string
  default     = "us-east1-b"
}

variable "nodecount" {
  description = "number of nodes"
  type        = number
  default     = 1
}

variable "nodetype" {
  description = "type of nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "whitelist-ips" {
  description = "ip's allowed to access k8s controlplane"
  type        = list(string)
  default     = ["185.207.249.37/32"]
}

variable "oauth_client_id" {
  description = "Oauth client ID from GCP to enable IAP"
  type        = string
  sensitive   = true
}

variable "oauth_client_secret" {
  description = "Oauth client secret from GCP to enable IAP"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name used for ingress"
  type        = string
  default     = "jlittle.xyz"
}

variable "argocd_version" {
  description = "Version for ArgoCD"
  type        = string
  default     = "5.16.13"
}

variable "argocd_admin_password" {
  description = "Admin PW for ArgoCD"
  type        = string
  sensitive   = true
}

variable "tls_key_path" {
  description = "Path on local file system to the TLS key used for IAP."
  type        = string
  default     = "/home/jered/.tls/key.pem"
}

variable "tls_cert_path" {
  description = "Path on local file system to the TLS cert used for IAP."
  type        = string
  default     = "/home/jered/.tls/cert.pem"
}

variable "tls_secret_name" {
  description = "Name of the TLS secret which is bootstrapped to the cluster"
  type        = string
  default     = "iap-tls"
}

variable "compute_plane_namespace" {
  type = string
  description = "The namespace where the main compute plane resources live."
  default = "compute-plane"
}

variable "argo_master_app_repo_url" {
  type = string
  description = "The Github repo URL which hosts the Argo applications"
  default = "https://github.com/JeredLittle1/team-engineering.git"
}

variable "argo_master_app_repo_branch" { 
  type = string
  description = "The branch to use for the argo master app repo"
  default = "gcp"
}

variable "sealed_secrets_secret_id" {
  type = string
  description = "The secret ID to bootstrap the certs for sealed secrets to"
  default = "sealed-secrets-tls"
}

variable "sealed_secrets_tls_cert_path" { 
  type = string 
  description = "The TLS cert path for sealed secrets locally."
  default = "~/.sealed-secrets/certs/mytls.crt"
}
variable "sealed_secrets_tls_key_path" { 
  type = string 
  description = "The TLS key path for sealed secrets locally."
  default = "~/.sealed-secrets/certs/mytls.key"
}

/*
variable "iap_users" {
  type = list
  description = "The list of users who you want to add to be authorized to login via IAP"
  default = [
      "user:jeredlittle1996@gmail.com",
    ]
}
*/