## Important Note on WSL
If using WSL2 with windows to run your cluster, make sure to create a `.wslconfig` file in your users home directory on Windows. Inside this file, limit the memory and swap that is allocated to the VM:

```
[wsl2]
memory=4GB
swap=2GB
```

If you do not do this, it could result in poor performance or crashes. 

* See: https://learn.microsoft.com/en-us/windows/wsl/wsl-config
* and: https://github.com/microsoft/WSL/issues/4166

## Setup

### Pre-requisites
1. Install a docker environment locally via Docker Desktop or Rancher Desktop
2. Install the `kind` CLI: https://kind.sigs.k8s.io/docs/user/quick-start/

### Steps

1. Open your terminal inside this folder (`local/`).
2. Create the cluster by running `kind create cluster --config kind_cluster.yaml`
3. If you only want to start certain services, go to the `kubernetes_argo-master-apps.tf` file
and comment out the services you do not wish to start. **Note: ArgoCD and Sealed Secrets are always required.**
4. Run `terraform apply` to create the services in your `kind` k8s cluster.


### Setting up port forwarding using Kubectl & Kind
Once you have applied all the terraform infrastructure, you need to port forward all the services in the cluster using `kubectl`. Here is an example:

1. Run `kubectl get services -n compute-plane` to see all the available services:
```
NAME                                                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/argo-workflows-server                            NodePort    10.96.9.8       <none>        2746:32005/TCP               69s
service/argocd-applicationset-controller                 ClusterIP   10.96.40.117    <none>        7000/TCP                     111s
service/argocd-redis                                     ClusterIP   10.96.148.14    <none>        6379/TCP                     111s
service/argocd-repo-server                               ClusterIP   10.96.205.184   <none>        8081/TCP                     111s
service/argocd-server                                    NodePort    10.96.8.197     <none>        80:30080/TCP,443:30443/TCP   111s
service/hub                                              ClusterIP   10.96.64.101    <none>        8081/TCP                     6s
service/kube-prometheus-stack-alertmanager               ClusterIP   10.96.20.197    <none>        9093/TCP                     65s
service/kube-prometheus-stack-grafana                    NodePort    10.96.182.230   <none>        80:31856/TCP                 65s
service/kube-prometheus-stack-kube-state-metrics         ClusterIP   10.96.103.177   <none>        8080/TCP                     65s
service/kube-prometheus-stack-operator                   ClusterIP   10.96.188.158   <none>        443/TCP                      65s
service/kube-prometheus-stack-prometheus                 ClusterIP   10.96.130.4     <none>        9090/TCP                     65s
service/kube-prometheus-stack-prometheus-node-exporter   ClusterIP   10.96.17.104    <none>        9100/TCP                     65s
service/proxy-api                                        ClusterIP   10.96.222.68    <none>        8001/TCP                     6s
service/proxy-public                                     NodePort    10.96.22.27     <none>        80:30765/TCP                 6s
service/sealed-secrets                                   ClusterIP   10.96.174.89    <none>        8080/TCP                     70s
```

2. Find the service you want to connect to. In this case, we will use `argocd-server`. Note, the port for the service is either `80` or `443` Next, run the following `kubectl` command to port-forward the service to be available locally on port `8443`:

```
kubectl port-forward service/argocd-server 8443:443 -n compute-plane
```

3. Navigate to your browser, and go to `127.0.0.1:8443/` to see the argocd webserver.

