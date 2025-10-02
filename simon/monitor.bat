
# https://cloudnative-pg.io/documentation/current/quickstart/


helm repo add prometheus-community   https://prometheus-community.github.io/helm-charts

helm upgrade --install   -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/kube-stack-config.yaml   prometheus-community  prometheus-community/kube-prometheus-stack

# import https://github.com/cloudnative-pg/grafana-dashboards/blob/main/charts/cluster/grafana-dashboard.json