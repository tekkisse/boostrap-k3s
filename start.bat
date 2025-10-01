# Create namespace if it doesn’t exist
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for deployments to be ready
kubectl wait --for=condition=available deployment   --all -n argocd --timeout=300s

# Get apssword
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo

kubectl apply -f github-secret.yaml
kubectl apply -f application.yaml



