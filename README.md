# tpe-redes

## Authors

- Juan Martín Barmasch <jbarmasch@itba.edu.ar>
- Mateo Bartellini Huapalla <mbartellini@itba.edu.ar>
- Juan Negro <jnegro@itba.edu.ar>

## Requirements

- `docker`
- `minikube`

## Installation

All of these instructions are to be followed inside this repository's root directory.

- Run `docker build -t tpe-redes-fastapi .`.
  - This will build an image named "tpe-redes-fastapi" based on the `Dockerfile` in this repository.
  - The image built runs a FastAPI
- Run `minikube start`
  - This will try to start the `minikube` cluster using `kubectl`.
  - If it does not find `kubectl` on your computer, it will download it on its own.
- Run `minikube image load tpe-redes-fastapi`
  - This will load the previously built image onto the cluster
  - Another option would be to run `minikube image build -t tpe-redes-fastapi .`, which will build the image directly inside `minikube`
    to avoid building it with `docker` and loading it afterwards.
- Run `kubectl apply -f k8s/deploy.yaml`
