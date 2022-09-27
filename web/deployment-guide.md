1. Test Django
```
python manage.py test
```

2. Retrieve an authentication token and authenticate your Docker client to your registry and Build Container

```
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-number>.dkr.ecr.<region>.amazonaws.com \
docker build -t django-k8s-web . \
docker tag django-k8s-web:latest <account-number>.dkr.ecr.<region>.amazonaws.com/django-k8s-web:latest
docker tag django-k8s-web:latest <account-number>.dkr.ecr.<region>.amazonaws.com/django-k8s-web:v1
```

3. Push Container with tags:latest
```
docker push <account-number>.dkr.ecr.<region>.amazonaws.com.com/django-k8s-web:latest
```

4. Update secrets (if needed)
```
kubectl delete secret django-k8s-web-prod-env
kubectl create secret generic django-k8s-web-prod-env --from-env-file=web/.env.prod
```

5. Update Deployment 
```
kubectl apply -f k8s/apps/django-k8s-web.yaml
```  

6. Add in a rollout strategy:
```
kubectl rollout status deployment/django-k8s-web-deployment
```

imagePullPolicy: Always

7. Get a single pod
```
export SINGLE_POD_NAME=$(kubectl get pod -l app=django-k8s-web-deployment -o jsonpath="{.items[0].metadata.name}")
```
or
```
export SINGLE_POD_NAME=$(kubectl get pod -l=app=django-k8s-web-deployment -o NAME | tail -n 1)
```

8. Migrate the Database: 
```
kubectl exec -it $SINGLE_POD_NAME -- bash /app/migrate.sh
```
