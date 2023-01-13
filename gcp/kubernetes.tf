resource "kubectl_manifest" "namespace" {
  yaml_body = yamlencode({
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = var.compute_plane_namespace
    }
  })
}

resource "kubectl_manifest" "gcp-oauth-secret" {
  yaml_body = yamlencode({
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = "gcp-oauth"
      "namespace" = var.compute_plane_namespace
    }
    "data" = {
        "client_id" : base64encode(var.oauth_client_id),
        "client_secret" : base64encode(var.oauth_client_secret)
    }
  })
}

resource "kubectl_manifest" "tls-secret" {
  yaml_body = yamlencode({
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = var.tls_secret_name
      "namespace" = var.compute_plane_namespace
    }
    "type" : "kubernetes.io/tls",
    "data" = {
        "tls.crt" : base64encode(file(var.tls_cert_path)),
        "tls.key" : base64encode(file(var.tls_key_path))
    }
  })
}


resource "kubectl_manifest" "iap-config" {
  yaml_body = yamlencode({
    "apiVersion" = "cloud.google.com/v1"
    "kind"       = "BackendConfig"
    "metadata" = {
      "name"      = "iap-config"
      "namespace" = var.compute_plane_namespace
    }
    "spec" = {
        "iap" : {
            "enabled" : true,
            "oauthclientCredentials" : {
                "secretName" : "gcp-oauth"
            }
        }
    }
  })
  depends_on = [
    resource.kubectl_manifest.gcp-oauth-secret
  ]
}

/*
resource "kubectl_manifest" "certificate" {
  yaml_body = yamlencode({
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "ManagedCertificate"
    "metadata" = {
      "name"      = "managed-cert"
      "namespace" = "argocd"
    }
    "spec" = {
        "domains" : [
          "${var.domain_name}",
          "argocd.${var.domain_name}"
        ]
    }
  })
}
*/


resource "kubectl_manifest" "ingress" {
  yaml_body = yamlencode({
    "apiVersion" : "networking.k8s.io/v1",
    "kind" : "Ingress",
    "metadata" : {
      "name" : "${var.compute_plane_namespace}-ingress",
      "namespace" : var.compute_plane_namespace,
      "annotations" : {
        # "ingress.kubernetes.io/rewrite-target" : "/",
        # Note: Make sure below is a GLOBAL IP address in GCP! Not REGIONAL!
        "kubernetes.io/ingress.global-static-ip-name" : "${var.compute_plane_namespace}-ip",
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
            "paths" : local.ingress_paths
          }
        }
      ]
    }
  })
  depends_on = [
    module.argocd,
    resource.google_compute_global_address.static_ip
  ]
}
