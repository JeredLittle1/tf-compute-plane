argocd_version = "5.16.13"
default_role = "role:admin"
rbac_scopes = "[groups]"
domain_name = "test.org"
sealed_secrets_tls_key_path = "~/.sealed-secrets/certs/mytls.key"
sealed_secrets_tls_cert_path = "~/.sealed-secrets/certs/mytls.crt"
sealed_secrets_secret_id = "sealed-secrets-tls"
sso_secret_id = "sso-secret"
sso_config_secret_map = {
    "test" : "test"
}