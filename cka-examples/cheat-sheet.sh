#Run command

kubectl run nginx --image=nginx

kubectl run nginx --image=nginx --dry-run=client -o yaml

kubectl create deployment --image=nginx nginx

#Generates a deployment.yaml
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

kubectl create -f nginx-deployment.yaml

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml



#pods 

kubectl get pods
kubectl run nginx --image nginx
kubectl get pods -o wide #To get details of the nodes along with the pod
kubectl describe pod nginx #To show the pod details , node details can be found as well
kubectl delete pod webapp  # delete pod with pod name/id
kubectl run redis --image=redis123 --dry-run=client -o yaml > redis-definition.yaml # to create yaml file
kubectl create -f redis-definiton.yaml 
kubectl edit pods redis # to edit the pods definition
kubectl apply -f redis-definition.yaml
kubectl edit pod <pod name> 
kubectl create -f /tmp/kubectl-edit-ccvrq.yaml #Create pod with temporary file 
kubectl get pod webapp -o yaml > my-new-pod.yaml # extract pod yaml file
kubectl edit deployment my-deployment # Edit deployments
kubectl replace -f elephant.yaml --force # Deletes the existing pod and replaces with new file




#replica sets 

kubectl get replicasets
kubectl describe replicasets
kubectl create -f replicasets-definition-2.yaml
kubectl edit replicasets new-replica-set # Note need to delete the running pods to create new ones
kubectl scale rs new-replica-set --replicas=5
kubectl get po #instead of pods
kubectl get rs # we can use rs instead of replica sets 

# Deployments
kubectl get deployment
kubectl create -f deployment.yaml


# Services

kubectl get service 
kubectl get svc
kubectl descibe svc kubernetes

#Namespaces 

kubectl get po --Namespace=dev
kubectl config set-context $(kubectl config curent-context) --namespace=dev
kubectl get pods -all-namespaces
kubectl get namespaceskube
kubectl get po --all-namespaces


#Daemon Sets 
kubectl get DaemonSets --all-namespaces
kubectl describe daemonset kube-proxy --namespace=kube-system #Find the nodes where the daemonsets is deployed.

#Static Pods (Deployign as static pod)
kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
#To edit a static pod simply change the deifinition file
kubectl run --restart=Never --image=busybox:1.28.4 static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml

#Multiple scheduler
kubectl create -f my-scheduler.yaml