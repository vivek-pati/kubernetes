# Approach 1 

#List all deployments 
kubectl get deploy --all-namespaces

#Check version of ETCD 
kubectl -n kube-system logs etcd-controlplane | grep -i 'etcd-version'
kubectl -n kube-system describe pod etcd-controlplane | grep Image:

#check the IP and port ETCD is running on
kubectl -n kube-system describe pod etcd-controlplane | grep '\--listen-client-urls'

#check ETCD Server certificate location
kubectl -n kube-system describe pod etcd-controlplane | grep '\--cert-file'

#check for the location of ca.cert

#Snapshot of ETCD database using default snapshot functionality
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db

#if etcdctl not present use etcd-backup-restore.md


#Restoring cluster from backup 
ETCDCTL_API=3 etcdctl  --data-dir /var/lib/etcd-from-backup \
snapshot restore /opt/snapshot-pre-boot.db

#Edit location of the ETDC db , in the /etc/kubernetes/manifests/etcd.yaml , property --data-dir
#Update volume mountPath=to the backup location after changing the yaml
#update the hostpath location.