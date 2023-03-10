locals {
  gcp_enabled   = true
  iap_enabled   = true
  local_enabled = false
  helm_app_configs = [
    {
      "name" : "argo-events-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : var.argo_master_app_repo_branch,
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
      "targetRevision" : var.argo_master_app_repo_branch,
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
      "targetRevision" : var.argo_master_app_repo_branch,
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
      "targetRevision" : var.argo_master_app_repo_branch,
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
      "targetRevision" : var.argo_master_app_repo_branch,
      "githubSubPath" : "sealed-secrets/"
      "helmValues" : {}
    },
    {
      "name" : "airbyte-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : var.argo_master_app_repo_branch,
      "githubSubPath" : "airbyte/"
      "helmValues" : {
        "gcp" : {
          "enabled" : local.gcp_enabled,
          "iap" : {
            "enabled" : local.iap_enabled
          }
        }
      }
    },
    {
      "name" : "spark-operator-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : var.argo_master_app_repo_branch,
      "githubSubPath" : "spark-on-k8s-operator/"
      "helmValues" : {
        "extraServiceAccounts" : [
          { "name" : "airflow-scheduler", "namespace" : var.compute_plane_namespace },
          { "name" : "spark-operator", "namespace" : var.compute_plane_namespace },
          { "name" : "airflow-worker", "namespace" : var.compute_plane_namespace }
        ]
      }
    },
    {
      "name" : "airflow-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : var.argo_master_app_repo_branch,
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
            },
            {
              "envName" : "AIRFLOW_CONN_KUBERNETES_DEFAULT",
              "secretName" : "airflow-kubernetes-default",
              "secretKey" : "AIRFLOW_CONN_KUBERNETES_DEFAULT"
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
    },
    {
      "name" : "mlflow-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : var.argo_master_app_repo_branch,
      "githubSubPath" : "mlflow/"
      "helmValues" : {
        "mlFlow" : {
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
      "name" : "superset-master",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.argo_master_app_github_repo,
      "targetRevision" : var.argo_master_app_repo_branch,
      "githubSubPath" : "superset/"
      "helmValues" : {
        "mlFlow" : {
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
    {
      "name" : "team-workflows",
      "namespace" : var.compute_plane_namespace,
      "project" : "default",
      "githubRepoUrl" : var.team_repo_url,
      "targetRevision" : var.team_repo_branch,
      "githubSubPath" : "workflows/"
      "helmValues" : {}
    }
  ]
}
