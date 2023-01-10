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
variable sso_config_secret_map { 
  type = map
  sensitive = true
}
variable sso_secret_id {
  type = string
}

variable sso_namespaces {
  type = list
  description = "All the namespaces to bootstrap the SSO secret to"
}

resource "kubernetes_namespace" "sealed-secrets-namespace" {
  metadata {
    name = "sealed-secrets"
  }
}

resource "kubernetes_namespace" "sso_namespaces" {
  for_each = { for ns in var.sso_namespaces: ns => ns }
  metadata {
    name = each.key
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

resource "kubernetes_manifest" "sso-secret" {
  for_each = { for ns in var.sso_namespaces: ns => ns }
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = var.sso_secret_id
      "namespace" = each.key
    }
    "data" = var.sso_config_secret_map
  }
}