#Manually scheduling - scheduler pod is removed 
#scheduler pod is present under --name-space kube-system

kubectl get po --namespace kube-system # to check if the scheduler pod is present



#Labels and Selector
kubectl get po --selector env=dev # to fetch all pods with env=dev label
kubectl get all --selector env=prod --no-headers | wc -l # To get all obejects where env=prod

#POD which is part of the prod environment, the finance BU and of frontend tier
kubectl get all --selector env=prod,bu=finance,tier=frontend 

#Taints and Toleration 
kubectl taint nodes node01 spray=mortein:NoSchedule # Create taint on node01 
kubectl describe nodes controlplane | grep Taint #find tait in a node
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule- # to untaint a node

# Node selectors 
kubectl label nodes node01 env=prod # nodes <nodename > <key>=<value>
kubectl label node node01 color=blue
kubectl create deployment blue --image=nginx --replicas=3