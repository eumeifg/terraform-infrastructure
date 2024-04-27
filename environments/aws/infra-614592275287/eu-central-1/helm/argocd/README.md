# How to install.

We have to get rid of terragrunt integration and switch to manuall installtion for now due to inability to split the values file and sensitive data conveniently.

In order to install please make sure you use correct K8s context:
```
kubectl config get-contexts -o name
kubectl config use-context eks-creative-advtech-infra
```

next you can execute the following helm commands:
```
helm secrets diff upgrade --dry-run -f values.yaml -f secrets://values.enc.yaml argocd argo/argo-cd --version 5.32.0 --set crds.install=false

helm secrets upgrade --dry-run -f values.yaml -f secrets://values.enc.yaml argocd argo/argo-cd --version 5.32.0 --set crds.install=false

helm secrets upgrade -f values.yaml -f secrets://values.enc.yaml argocd argo/argo-cd --version 5.32.0 --set crds.install=false
```

NOTE: We need to address CRD upgrade as we skip it for now.
