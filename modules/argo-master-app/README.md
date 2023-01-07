## Description
This module is used to bootstrap the main argo application for a team. This is done with a helm chart located at `./helm/`. The `github_repo_url` determines where the applications for a specific team reside. For example, here are the applications which are bootstrapped for `team_engineering/argo-master-apps/`:

```
team-engineering/argo-master-apps/
├── airflow_application.yaml
├── argo-events_application.yaml
├── argo-workflows_application.yaml
├── jupyterhub_application.yaml
├── nginx_application.yaml
├── sealed-secrets_application.yaml
└── secrets_application.yaml
```

**Note: All applications must be under the folder `argo-master-apps/` in the Github repo`

[See this link for helm chart.](https://artifacthub.io/packages/helm/argo/argo-cd)