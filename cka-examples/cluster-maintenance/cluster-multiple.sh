# Working with multiple cluster
#check the number of cluster the system has access to 
kubectl get node 
kubectl config view # show all clusters that are conifured 

#Check nodes in each cluster 
kubectl config use-context clustername # switch the context
kubectl get nodes #get the nodes

#check the etcd of the cluster , if the Etcd stacked
kubectl get pods -n kube-system | grep etcd #check for the ETCD pod

#check ip of external ETCD DB, if the etcd is external . check the value in api server etcd server
ssh cluster2-controlplane ps -ef | grep --color=auto etcd

#check the data directory of etcd datastore
kubectl -n kube-system describe pod etcd-cluster1-controlplane | grep data-dir

#for external etcd, we need to ssh into the external server 
#References 
#https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster

#https://github.com/etcd-io/website/blob/main/content/en/docs/v3.5/op-guide/recovery.md

#https://www.youtube.com/watch?v=qRPNuT080Hk