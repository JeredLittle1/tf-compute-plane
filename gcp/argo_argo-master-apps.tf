resource "kubectl_manifest" "argo-helm-master-app" {
  for_each = { for config in local.helm_app_configs : config.name => config }
  yaml_body = yamlencode({
    "apiVersion" : "argoproj.io/v1alpha1",
    "kind" : "Application",
    "metadata" : {
      "name" : each.value.name,
      "namespace" : each.value.namespace,
    },
    "spec" : {
      "project" : each.value.project,
      "source" : {
        "repoURL" : each.value.githubRepoUrl,
        "targetRevision" : each.value.targetRevision,
        "path" : each.value.githubSubPath,
        "helm" : {
          "values" : yamlencode(each.value.helmValues)
        }
      },
      "destination" : {
        "server" : "https://kubernetes.default.svc",
        "namespace" : each.value.namespace
      },
      "syncPolicy" : {
        "syncOptions" : [
          "CreateNamespace=true"
        ],
        "automated" : {
          "selfHeal" : true,
          "prune" : true
        }
      }
    }
  })
  depends_on = [
    module.argocd
  ]
}

resource "kubectl_manifest" "argo-master-app" {
  for_each = { for config in local.app_configs : config.name => config }
  yaml_body = yamlencode({
    "apiVersion" : "argoproj.io/v1alpha1",
    "kind" : "Application",
    "metadata" : {
      "name" : each.value.name,
      "namespace" : each.value.namespace,
    },
    "spec" : {
      "project" : each.value.project,
      "source" : {
        "repoURL" : each.value.githubRepoUrl,
        "targetRevision" : each.value.targetRevision,
        "path" : each.value.githubSubPath,
        "directory" : {
            "recurse" : true
        }
      },
      "destination" : {
        "server" : "https://kubernetes.default.svc",
        "namespace" : each.value.namespace
      },
      "syncPolicy" : {
        "syncOptions" : [
          "CreateNamespace=true"
        ],
        "automated" : {
          "selfHeal" : true,
          "prune" : true
        }
      }
    }
  })
  depends_on = [
    module.argocd
  ]
}