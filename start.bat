# Create namespace if it doesn’t exist
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for deployments to be ready
kubectl wait --for=condition=available deployment   --all -n argocd --timeout=300s

# Enable HELM in ArgoCD
kubectl patch configmap argocd-cm -n argocd --type merge   -p '{"data":{"kustomize.buildOptions":"--enable-helm"}}'
kubectl rollout restart deploy argocd-repo-server -n argocd

# Rollout boot strap
kubectl apply -f bootstrap/argocd-project.yaml
kubectl apply -f bootstrap/github-secret.yaml
kubectl apply -f bootstrap/bootstrap.yaml

# cloudnativePG not through argocd ?
# kubectl apply --server-side -f   https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.26/releases/cnpg-1.26.0.yaml

# Get argocd password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" 

# Forward ArgoCD interface to port 8080
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0




