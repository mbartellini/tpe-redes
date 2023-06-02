kind create cluster --config k8s/cluster-config.yaml

cd ./src/v1 && docker compose build
cd ../v2 && docker compose build

cd ../../
kind load docker-image v1-redes-api v2-redes-api --name redes-cluster

kubectl apply -f src/
kubectl apply -f src/v1/k8s/
kubectl apply -f src/v2/k8s/
