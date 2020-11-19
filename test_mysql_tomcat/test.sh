#!/bin/bash

kubectl cluster-info
kubectl get nodes
git clone https://github.com/copdips/katacoda-scenarios.git
cd katacoda-scenarios/test_mysql_tomcat
kubectl apply -f mysql_rc.yml
kubectl apply -f mysql_svc.yml
kubectl get svc
mysql_svc_ip=$(kubectl get svc | grep mysql-svc | awk '{print $3}')
echo $mysql_svc_ip
sed -i "s/my_sql_service_ip_to_replace/$mysql_svc_ip/g" tomcat_rc.yml
kubectl apply -f tomcat_rc.yml
kubectl apply -f tomcat_svc.yml
kubectl get rs
kubectl scale rs myweb --replicas=3
kubectl get rs -o wide
kubectl describe rs myweb
kubectl describe svc myweb

# check logs and exit
kubectl get pods | grep myweb | tail -n 1 | awk '{print $1}' | xargs kubectl logs
# continue to check logs
kubectl get pods | grep myweb | tail -n 1 | awk '{print $1}' | xargs kubectl logs -f

# check svc ip is mapped to nodes' IP
ipvsadm -Ln


# Let svc for external access, change svc type from ClusterIP (internal IP) to NodePort

# note type and port(s)
kubectl get svc
kubectl edit svc mysql-svc
# recheck the type and port(s) new values, and be aware that the change will apply to all node s.
kubectl get svc

# update image
kubectl set image --help
kubectl set image deployment/my-app my-app=myapp:v2
