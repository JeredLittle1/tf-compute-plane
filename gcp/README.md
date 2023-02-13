# About
This folder contains all of the Terraform HCL code to bootstrap a GKE cluster. 

## Prerequisites
In order to apply these Terraform configs, you must first:

1. Buy a Cloud Domain from Google (Used for DNS): https://cloud.google.com/domains/docs/overview
2. Set up OAuth on GCP and obtain a client id and secret key (used for IAP): https://support.google.com/cloud/answer/6158849?hl=en
3. Create a TLS cert for Sealed Secrets (Used to encrypt your secrets): https://github.com/bitnami-labs/sealed-secrets/blob/main/docs/bring-your-own-certificates.md
- Note: If using the default `team-engineering` repo in the `variables.tf` file, the secrets will not be decrypted (because I own the private key for these!). You will need to fork the repo and encrypt your own secrets.
4. Create a cert for IAP (Self-signed - Your browser will throw a warning when logging in): https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#create-key-and-cert

The following items are created when you run `terraform apply` in this folder:

## VPC Configurations
The VPC components configured are as follows:
1. A VPC and subnetwork in GCP
2. The NAT gateway & configuration for the GKE cluster to communicate with the internet

## GKE Configuration
The K8S cluster configuration for this project is:
1. A GKE cluster with a single node pool using the VPC/subnetwork above.

## DNS
The DNS configurations used to route traffic to K8S are:
1. A static IP address used for a SINGLE Ingress Load Balancer to all the applications in the cluster.
    - Note: This was done to reduce the cost of having multiple LBs/static IPs route to different applications. However, it does add additional overhead of having to modify `kubernetes_boostrap-configs.locals.tf` every time you need a new ingress rule.
2. A DNS Zone with multiple subdomain records pointing to the static IP above.

## Kubernetes Manifests & Bootstrapping
The K8S cluster is bootstrapped with different helm charts & manifests. Here are the different apps/configs bootstrapped to the cluster:
1. ArgoCD bootstrapped to the cluster to manage application CD.
2. Sealed Secrets bootstrapped to the cluster with a custom TLS cert/key.
3. ArgoCD manifests bootstrapped to the cluster which point to a DIFFERENT GitHub repo containing all your applications to be managed with ArgoCD. See: `kubernetes_argo-master-apps.locals.tf`
    - In this case, we are using applications found here: https://github.com/JeredLittle1/argo-master-app/
    - Once bootstrapped, all application releases from the `argo-master-app` repo are automatically synced using ArgoCD.
    - The only reason to modify this Terraform code after release is to:
        - Add/change configs to existing `kubernetes_argo-master-apps.locals.tf` apps.
        - Add new applications to the cluster. In which case, you will also need to modify `kubernetes_boostrap-configs.locals.tf`
4. An Ingress configuration which routes traffic to all backend applications. See: `kubernetes_boostrap-configs.locals.tf`

## Authentication
The ingress load balancer is configured with IAP.


## TODOs
* Since this use case involves creating an external Postgres instance for Airflow, we need a new CloudSQL instance & the configs need to be bootstrapped to the Argo app controlling Airflow.
* The Airflow app could be better managed for connections. Right now, a new secret has to be created AND a change must be made to add it to the pods as an environment variable. Ideally, if the secret is created, this should be automatic.
* 
