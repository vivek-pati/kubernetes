kubectl get po -o wide #To check the nodes where the pods are deployed/ to find nodes where app is deployed.
kubectl get deploy #To check how many applications are running.

#To upgrade a node or put in maintenance mode
kubectl drain node01 # node name, 
kubectl drain node01 --ignore-daemonsets
kubectl cordon node01 # To mark the node unschedulable and keep the pods running and node running
kubectl drain --force # This will destroy the pods that are not part of replica sets and can never be retrived.

#To put a node out of maintenance mode
kubectl uncordon node01 



####Upgrading a cluster

# 1 Check the version 
kubectl get nodes #Check the version

# 2 Check the number of nodes 
kubectl get nodes

# 3 Check the nodes and deployments to what pods and can be deployed in which nodes
kubectl describe nodes nodename | grep Taints # check for taints in all nodes
kubectl describe deploy blue | grep Tolerations # check for tolerations in all deployments

# 4 Check pods deployed on what nodes
kubectl get po -o wide 

# 5 Drain on by one each node 
kubectl drain nodename --ignore-daemonsets 


# 6 Upgrade kubeadm and cluster

vi /etc/apt/sources.list.d/kubernetes.list  #update the version number in the kubnernetes.list file
#change the version by 1 minor version.
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /

    #update kubeadm 
    apt update
    apt-cache madison kubeadm
    apt-get install kubeadm=1.31.0-1.1

    #Run kubeadm plan check the result and run apply 
    kubeadm upgrade plan v1.31.0
    kubeadm upgrade apply v1.31.0

    #Update kubelet version
    apt-get install kubelet=1.31.0-1.1

    #refresh the systemd configuration and apply changes to the Kubelet service
    systemctl daemon-reload
    systemctl restart kubelet

    #Uncordon the nodes 
    kubectl uncordon nodename

#Upgrade the worker node 
ssh nodename
vi /etc/apt/sources.list.d/kubernetes.list  #update the version number in the kubnernetes.list file
#change the version by 1 minor version.
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /

    #update kubeadm 
    apt update
    apt-cache madison kubeadm
    apt-get install kubeadm=1.31.0-1.1

    # Upgrade the node 
    kubeadm upgrade node

     #refresh the systemd configuration and apply changes to the Kubelet service
    systemctl daemon-reload
    systemctl restart kubelet

    #Uncordon the nodes 
    kubectl uncordon nodename