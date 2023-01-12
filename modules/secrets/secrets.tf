variable tls_cert_value { 
  type = string 
  sensitive = true
}
variable tls_key_value { 
  type = string 
  sensitive = true
}
variable sealed_secret_id { 
  type = string
}
resource "kubernetes_namespace" "sealed-secrets-namespace" {
  metadata {
    name = "sealed-secrets"
  }
}
resource "kubernetes_manifest" "sealed-secrets-tls-secret" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = var.sealed_secret_id
      "namespace" = "sealed-secrets"
      "labels" : {
        "sealedsecrets.bitnami.com/sealed-secrets-key" : "active"
      }
    }
    "data" = {
      "tls.crt" = var.tls_cert_value
      "tls.key" = var.tls_key_value
    }
  }
  depends_on = [
    kubernetes_namespace.sealed-secrets-namespace
  ]
}