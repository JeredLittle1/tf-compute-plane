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

variable namespace {
  type = string
}
resource "kubectl_manifest" "sealed-secrets-tls-secret" {
  yaml_body = yamlencode({
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = var.sealed_secret_id
      "namespace" = var.namespace
      "labels" : {
        "sealedsecrets.bitnami.com/sealed-secrets-key" : "active"
      }
    }
    "data" = {
      "tls.crt" = var.tls_cert_value
      "tls.key" = var.tls_key_value
    }
  })
}