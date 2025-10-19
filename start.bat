REM Create namespace if it doesn’t exist
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

REM Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

REM Wait for deployments to be ready
kubectl wait --for=condition=available deployment   --all -n argocd --timeout=300s

REM Enable HELM in ArgoCD
kubectl patch configmap argocd-cm -n argocd --type merge   -p '{"data":{"kustomize.buildOptions":"--enable-helm"}}'
kubectl rollout restart deploy argocd-repo-server -n argocd

REM Rollout boot strap
kubectl apply -f bootstrap/argocd-project.yaml
kubectl apply -f bootstrap/github-secret.yaml
kubectl apply -f bootstrap/bootstrap.yaml

REM cloudnativePG not through argocd ?
REM# kubectl apply --server-side -f   https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.26/releases/cnpg-1.26.0.yaml

REM Get argocd password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" 

REM Forward ArgoCD interface to port 8080
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0




