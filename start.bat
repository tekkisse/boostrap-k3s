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

# Get argocd password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" 




