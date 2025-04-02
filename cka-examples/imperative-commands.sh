# Imperative commmands will be help to do things quickly and fast. Good for exam.

#POD
#Create an NGINX Pod
kubectl run nginx --image=nginx
kubectl run nginx-pod --image nginx:alpine
#Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)
kubectl run nginx --image=nginx --dry-run=client -o yaml

#Deploy pod with label set to tier=db 
kubectl run redis --image=redis:alpine --dry-run=client -oyaml > redis-pod.yaml # create yaml file and change label
kubectl run redis -l tier=db --image=redis:alpine

#Create a new pod called custom-nginx using the nginx image and run it on container port 8080
kubectl run custom-nginx --image=nginx --port=8080

#Create a pod called httpd using the image httpd:alpine in the default namespace. Next, create a service of type ClusterIP by the same name (httpd). The target port for the service should be 
kubectl run httpd --image=httpd:alpine --port=80 --expose

kubectl create deployment --image=nginx nginx
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml #Test dont create
kubectl create deployment nginx --image=nginx --replicas=4 # Deploy with replicas
kubectl scale deployment nginx --replicas=4 # Scale up or scale down
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml #Test don't create and create yaml file
kubectl create deploy redis-deploy --image=redis --namespace=dev-ns --replicas=2

#Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml #use pod lables as selectors automatically
#Create a new deployment called redis-deploy in the dev-ns namespace with the redis image. It should have 2 replicas.
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml #cannot pass pod selector as an option

# Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

#Practice Expose : Create a service redis-service to expose the redis application within the cluster on port 6379.
kubectl expose pod redis --port=6379 --name redis-service

#Creating a config map
kubectl create configmap  webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard

#Create secrets
kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
