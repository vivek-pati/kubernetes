#Updating deployments version

kubectl edit deployments frontend # edit the file to update the image

# Creating a config map imperative way
kubectl create configmap  webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard

# Creating secrets
kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123