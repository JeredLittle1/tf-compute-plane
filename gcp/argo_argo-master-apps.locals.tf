locals {
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
        "gcp" : {
          "enabled" : true,
          "iap" : {
            "enabled" : true
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
        "gcp" : {
          "enabled" : true,
          "iap" : {
            "enabled" : true
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
          "local" : false
        },
        "gcp" : {
          "enabled" : true,
          "iap" : {
            "enabled" : true
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
            "enabled" : false
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
          "enabled" : true,
          "iap" : {
            "enabled" : true
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