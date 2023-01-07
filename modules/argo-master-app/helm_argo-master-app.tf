variable github_repo_url { type = string }
variable app_name { type = string }

resource "helm_release" "argo-master-app" {
  name      = var.app_name
  chart     = "../modules/argo-master-app/helm/"
  namespace = "argocd"
  values = [
    yamlencode(
        {
          "githubRepo" : var.github_repo_url
        }
    )
  ]
}
