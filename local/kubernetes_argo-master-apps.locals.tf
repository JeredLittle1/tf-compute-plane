locals {
  gcp_enabled = false
  iap_enabled = false
  local_enabled = true
  helm_app_configs = [
    {
      "name" : "argo-events-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : "master",
      "githubSubPath" : "argo-events/"
      "helmValues" : {
        "argoEvents" : {
          "create" : true
        }
      }
    },
    {
      "name" : "argo-workflows-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : "master",
      "githubSubPath" : "argo-workflows/"
      "helmValues" : {
        "argoWorkflows" : {
          "local" : {
            "enabled" : local.local_enabled
          }
        },
        "gcp" : {
          "enabled" : local.gcp_enabled,
          "iap" : {
            "enabled" : local.iap_enabled
          }
        }
      }
    },
    {
      "name" : "jupyterhub-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : "master",
      "githubSubPath" : "jupyterhub/"
      "helmValues" : {
        "jupyterhub" : {
          "local" : {
            "enabled" : local.local_enabled
          }
        },
        "gcp" : {
          "enabled" : local.gcp_enabled,
          "iap" : {
            "enabled" : local.iap_enabled
          }
        }
      }
    },
    {
      "name" : "kube-prometheus-stack-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : "master",
      "githubSubPath" : "kube-prometheus-stack/"
      "helmValues" : {
        "grafana" : {
          "local" : {
            "enabled" : local.local_enabled
          }
        },
        "gcp" : {
          "enabled" : local.gcp_enabled,
          "iap" : {
            "enabled" : local.iap_enabled
          }
        }
      }
    },
    {
      "name" : "sealed-secrets-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : "master",
      "githubSubPath" : "sealed-secrets/"
      "helmValues" : {}
    },
    {
      "name" : "airflow",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.team_repo_url,
      "targetRevision" : "master",
      "githubSubPath" : "airflow/"
      "helmValues" : {
        "airflow" : {
          "local" : {
            "enabled" : local.local_enabled
          },
          "secret" : [
            {
              "envName" : "AIRFLOW_CONN_MY_COOL_AIRFLOW_CONNECTION",
              "secretName" : "my-cool-airflow-connection",
              "secretKey" : "AIRFLOW_MY_COOL_AIRFLOW_CONNECTION"
            }
          ],
          "image" : {
            "repository" : var.airflow_image,
            "tag" : "v1.0"
          },
          "mountConfig" : {
            "github" : {
              "repoUrl" : var.team_repo_url,
              "branch" : var.team_repo_branch,
              "rev" : "HEAD"
            }
          }
        },
        "gcp" : {
          "enabled" : local.gcp_enabled,
          "iap" : {
            "enabled" : local.iap_enabled
          }
        }
      }
    }
  ]
  app_configs = [
    {
      "name" : "team-secrets",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.team_repo_url,
      "targetRevision" : var.team_repo_branch,
      "githubSubPath" : "sealed-secrets/"
      "helmValues" : {}
    },
  ]
}
