kind create cluster --config k8s/cluster-config.yaml

istioctl install -y
kubectl apply -f prometheus/
kubectl apply -f kiali/

kubectl apply -f namespaces/
kubectl label namespace default istio-injection=enabled
kubectl label namespace ingress-nginx istio-injection=enabled

cd ./src/v1 && docker-compose build
cd ../v2 && docker-compose build

cd ../../
kind load docker-image v1-redes-api v2-redes-api --name redes-cluster

kubectl apply -f src/
kubectl apply -f src/v1/k8s/
kubectl apply -f src/v2/k8s/

kubectl apply -f ingress-nginx/controller-deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s && kubectl apply -f ingress-nginx/ingress-nginx.yaml
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8084:80