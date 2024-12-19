### **kube-controller-manager Overview**

The **kube-controller-manager** is a critical component of the Kubernetes control plane that runs various controllers responsible for maintaining the desired state of cluster objects. These controllers perform background tasks like ensuring the proper number of pods are running, handling node failures, managing endpoints, and more.

---

### **Key Roles of kube-controller-manager**
1. **Replication Controller**: Ensures the desired number of pod replicas.
2. **Node Controller**: Monitors node health and handles node failures.
3. **Endpoints Controller**: Updates endpoint objects for services.
4. **Service Account and Token Controllers**: Manages service accounts and API tokens.

---

### **Modifying kube-controller-manager in a Cluster Created with kubeadm**

#### **Location of kube-controller-manager**
- In a kubeadm cluster, the kube-controller-manager runs as a **static pod** managed by the kubelet.
- The static pod manifest is stored at:
  ```bash
  /etc/kubernetes/manifests/kube-controller-manager.yaml
  ```

---

### **Viewing and Modifying kube-controller-manager Configuration**

1. **Locate the kube-controller-manager Manifest**:
   - Open the static pod manifest:
     ```bash
     sudo vi /etc/kubernetes/manifests/kube-controller-manager.yaml
     ```

2. **Identify Key Options**:
   - The `command` section lists configuration flags. For example:
     ```yaml
     spec:
       containers:
       - command:
         - kube-controller-manager
         - --allocate-node-cidrs=true
         - --cluster-cidr=10.244.0.0/16
         - --service-cluster-ip-range=10.96.0.0/12
         - --controllers=*,bootstrapsigner,tokencleaner
         - --node-monitor-period=5s
         - --node-monitor-grace-period=40s
         - --pod-eviction-timeout=5m0s
     ```

3. **Modify Parameters**:
   - Edit parameters to change default values.
     - For example, to change the **pod replication wait time**, adjust the `--controller-start-interval` flag:
       ```yaml
       - --controller-start-interval=2s
       ```

4. **Restart kube-controller-manager**:
   - Since it's a static pod, the kubelet automatically restarts the kube-controller-manager when the manifest is updated.

5. **Verify Changes**:
   - Check the logs of the kube-controller-manager to ensure the updated settings are applied:
     ```bash
     kubectl logs -n kube-system kube-controller-manager-<node-name>
     ```

---

### **Modifying Default Options**

#### Example: Change the Pod Eviction Timeout
To adjust how long the system waits before evicting a pod from an unresponsive node, modify the `--pod-eviction-timeout` flag.

1. **Edit the Manifest**:
   - Locate and update the flag:
     ```yaml
     - --pod-eviction-timeout=2m
     ```

2. **Verify Pod Eviction**:
   - Simulate a node failure and observe pod eviction behavior to confirm the changes:
     ```bash
     kubectl cordon <node-name>
     kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
     ```

---

### **Viewing kube-controller-manager in Managed Kubernetes (EKS)**

In **EKS**, the kube-controller-manager is a managed component, and you cannot directly modify its settings. However, you can configure some behaviors indirectly through:
- **Cluster Autoscaler** for replica scaling.
- Custom Resource Definitions (CRDs) for controllers.
- IAM and service-linked roles for specific operations.

For advanced configuration or specific requirements, consider deploying your own controller using Kubernetes APIs.

---

### **Key Flags for kube-controller-manager**

| Flag                              | Description                                                                                                                                   |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `--pod-eviction-timeout`          | Time to wait before evicting pods from an unresponsive node (default: `5m0s`).                                                                |
| `--node-monitor-period`           | Frequency of node status checks (default: `5s`).                                                                                             |
| `--controllers`                   | List of controllers to run (`*` means all).                                                                                                  |
| `--horizontal-pod-autoscaler-sync-period` | Time between syncs for the Horizontal Pod Autoscaler (default: `15s`).                                                                    |
| `--enable-garbage-collector`      | Enables the garbage collector for cleaning up unused resources (default: `true`).                                                            |
| `--leader-elect`                  | Enables leader election to ensure only one kube-controller-manager is active in a multi-master setup (default: `true`).                     |

---

### **Best Practices for Managing kube-controller-manager**
1. **Backup Configuration**:
   - Before making changes to the static pod manifest, create a backup:
     ```bash
     sudo cp /etc/kubernetes/manifests/kube-controller-manager.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml.bak
     ```

2. **Test Changes in a Development Environment**:
   - Avoid applying changes directly to a production cluster without prior testing.

3. **Use Monitoring Tools**:
   - Integrate monitoring solutions like Prometheus and Grafana to track controller behavior and identify bottlenecks.

4. **Audit Logs**:
   - Regularly check logs for unexpected behavior:
     ```bash
     kubectl logs -n kube-system kube-controller-manager-<node-name>
     ```

5. **Cluster Scaling**:
   - Adjust replication-related parameters when dealing with large-scale clusters to optimize performance.

---
