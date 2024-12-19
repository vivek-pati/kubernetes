### **What is kube-scheduler?**

The **kube-scheduler** is a critical component of the Kubernetes control plane responsible for assigning Pods to nodes. It ensures that Pods are scheduled on appropriate nodes based on resource requirements, policies, and constraints.

---

### **Why Do We Need kube-scheduler?**
1. **Node Selection for Pods**:
   - The kube-scheduler ensures that each unscheduled Pod is placed on a node that meets its requirements.
   
2. **Efficient Resource Utilization**:
   - It optimizes cluster resources by considering CPU, memory, and other constraints.

3. **Policy Enforcement**:
   - Handles affinity/anti-affinity rules, taints, and tolerations.

4. **Custom Scheduling**:
   - Allows customization using custom schedulers for specific workloads.

---

### **How kube-scheduler Works**
1. **Pod Enters Pending State**:
   - A Pod is created without a `nodeName`, indicating it needs to be scheduled.

2. **Filtering Nodes**:
   - The scheduler evaluates all nodes and filters out those that don't meet the Pod's requirements.
     - Examples:
       - Node lacks sufficient CPU or memory.
       - Node is tainted, and the Pod doesn't tolerate the taint.

3. **Scoring Nodes**:
   - The scheduler assigns scores to the remaining nodes based on:
     - Proximity to other Pods (affinity).
     - Available resources.
     - Custom policies.

4. **Binding the Pod**:
   - The kube-scheduler selects the highest-scored node and updates the Pod's `spec.nodeName` field to bind it to the node.

---

### **Viewing and Modifying kube-scheduler Options**

#### **When Installed via kubeadm**

##### **Static Pod Manifest**
- The kube-scheduler runs as a **static pod**, and its configuration is defined in:
  ```bash
  /etc/kubernetes/manifests/kube-scheduler.yaml
  ```

##### **Viewing Options**
1. Open the static pod manifest:
   ```bash
   sudo vi /etc/kubernetes/manifests/kube-scheduler.yaml
   ```
2. Look for the `command` or `args` section. For example:
   ```yaml
   spec:
     containers:
     - command:
       - kube-scheduler
       - --kubeconfig=/etc/kubernetes/scheduler.conf
       - --leader-elect=true
       - --address=127.0.0.1
       - --port=10259
       - --bind-address=0.0.0.0
       - --config=/etc/kubernetes/scheduler-config.yaml
   ```

##### **Modifying Options**
1. Edit the YAML file to include desired flags or adjust existing ones.
2. Commonly adjusted flags:
   - `--leader-elect`: Enables leader election for HA setups.
   - `--config`: Specifies the path to a configuration file for more complex scheduling policies.
3. Save changes and exit. The kubelet automatically restarts the kube-scheduler.

##### **Using a Config File**
- Advanced configurations are typically specified in a config file:
  ```yaml
  apiVersion: kubescheduler.config.k8s.io/v1beta3
  kind: KubeSchedulerConfiguration
  profiles:
  - schedulerName: default-scheduler
    plugins:
      score:
        enabled:
        - name: NodeResourcesLeastAllocated
  ```
- Update the manifest to reference this file:
  ```yaml
  - --config=/etc/kubernetes/scheduler-config.yaml
  ```

---

#### **When Using EKS**

##### **Managed kube-scheduler**
- In Amazon EKS, the kube-scheduler is a **managed component**. You cannot directly view or modify its configuration.

##### **How to Influence Scheduling**
1. **Custom Schedulers**:
   - Deploy your own scheduler in the cluster to override default scheduling for specific workloads.

2. **Scheduling Features**:
   - Use Kubernetes-native features like:
     - Affinity/Anti-affinity rules.
     - Taints and tolerations.
     - Resource requests and limits.

3. **Logs and Monitoring**:
   - EKS doesn't expose the kube-scheduler directly, but you can enable and view its logs in **CloudWatch**:
     - Enable logging:
       ```bash
       aws eks update-cluster-config \
         --name <cluster-name> \
         --logging '{"clusterLogging":[{"types":["scheduler"],"enabled":true}]}'
       ```
     - View logs in CloudWatch under `/aws/eks/<cluster-name>/cluster`.

---

### **Differences Between kubeadm and EKS**

| Feature                        | kubeadm Cluster                              | EKS                                        |
|--------------------------------|----------------------------------------------|--------------------------------------------|
| **Location of kube-scheduler** | Runs as a static pod. Configurable via YAML. | Managed by AWS; configuration is not exposed. |
| **Access to Logs**             | `kubectl logs` or static pod logs.           | Accessible in CloudWatch if enabled.       |
| **Custom Configuration**       | Fully configurable (flags, config files).    | Limited to using custom schedulers or features. |

---

### **Key kube-scheduler Flags**

| Flag                      | Description                                                                                     |
|---------------------------|-------------------------------------------------------------------------------------------------|
| `--kubeconfig`            | Specifies the kubeconfig file to communicate with the API server.                              |
| `--leader-elect`          | Enables leader election for HA.                                                                |
| `--address`               | Address on which to listen for HTTP requests (default: `127.0.0.1`).                           |
| `--port`                  | Port for serving HTTP requests (default: `10259`).                                             |
| `--config`                | Specifies a file for scheduler configuration.                                                  |
| `--scheduler-name`        | Name of the scheduler (default: `default-scheduler`).                                           |

---

### **Best Practices**
1. **Backup Configuration**:
   - Always back up the static pod manifest before making changes:
     ```bash
     sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml /etc/kubernetes/manifests/kube-scheduler.yaml.bak
     ```

2. **Test in a Staging Environment**:
   - Test changes in a non-production environment to validate behavior.

3. **Use Node Affinity and Taints**:
   - Leverage these features for precise workload placement.

4. **Monitor Scheduler Performance**:
   - Use monitoring tools like Prometheus and Grafana to track scheduling latency and failures.

---
