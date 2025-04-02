# Enable Metrics server

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl top node #Memory / CPU usage of nodes
kubectl top po #Memory / CPO of pods
kubectl logs webapp-1 # application logs
kubectl logs webapp-2 -c simple-webapp # application logs