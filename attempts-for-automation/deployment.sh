#!/bin/sh

## deployment.sh default 19 
#
ns=$1
image_tag=$2
release_version= ??
cat <<EOF | kubectl -n ${ns} apply -f -
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: awesome
  labels:
    app: awesome
spec:
  replicas: 3
  selector:
    matchLabels:
      app: awesome
  template:
    metadata:
      name: task-pod
      labels:
        app: awesome
        released-by: kubectl-apply
    spec:
      containers:
        - name: task-container
          image: nginx:${image_tag}
          ports:
            - containerPort: 80
              name: http-server
          volumeMounts:
            # :/usr/share/nginx/html
          - mountPath: /usr/share/nginx/html # mount nginx-pages volumn to /usr/share/nginx/html
            readOnly: true
            name: nginx-pages-vol
      volumes:
      - name: nginx-pages-vol
        configMap:
          name: nginx-pages
          items:
            - key: index.html
              path: index.html

EOF