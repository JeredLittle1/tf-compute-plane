variable github_repo_url { type = string }
variable app_name { type = string }
variable "namespace" { type = string }

resource "helm_release" "argo-master-app" {
  name      = var.app_name
  chart     = "../modules/argo-master-app/helm/"
  namespace = var.namespace
  values = [
    yamlencode(
        {
          "githubRepo" : var.github_repo_url,
          "namespace"  : var.namespace
        }
    )
  ]
}
