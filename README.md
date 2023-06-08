# tpe-redes

El proyecto se probó para computadoras con Linux x86_64 (expecíficamente Ubuntu 22.04.2 LTS).

## Authors

- Juan Martín Barmasch <jbarmasch@itba.edu.ar>
- Mateo Bartellini Huapalla <mbartellini@itba.edu.ar>
- Juan Negro <jnegro@itba.edu.ar>

## Prerequisites

- `docker`, `docker compose`
- `kubectl`
- `kind`
- `istio`

### Instalación de Docker
1. Primero, actualizamos el índice de la herramienta `apt` e instalamos paquetes para usar repositorios sobre HTTPS:
```shell
  $ sudo apt-get update
  $ sudo apt-get install ca-certificates curl gnupg
```

2. Agregamos la llave GPG oficial de Docker:
```shell
  $ sudo install -m 0755 -d /etc/apt/keyrings
  $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc apt/keyrings/docker.gpg
  $ sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

3. Configuramos el repositorio:
```shell
  $ echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

4. Volvemos a actualizar el índice de paquetes de `apt`
```shell
  $ sudo apt-get update
```

5. Instalamos Docker Engine, containerd y Docker Compose:
```shell
  $ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

5. Verificamos la correcta instalación de Docker Engine corriente la imagen `hello-world`:
```shell
  $ sudo docker run hello-world
```
Se debería ver una salida similar en la consola:
```shell
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### Instalación de kind
Si se cuenta con `Homebrew`:
```shell
  $ brew install kind
```
Si no:
```shell
  $ [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-amd64
  $ chmod +x ./kind
  $ sudo mv ./kind /usr/local/bin/kind
```

### Instalación de Istio
1. Descargamos el archivo _release_ de Istio (versión 1.18.0):
```shell
  $ curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.18.0 TARGET_ARCH=x86_64 sh -
```
2. Nos movemos al directorio recién creado:
```shell
  $ cd istio-1.18.0
```
3. Imprimimos el directorio actual:
```shell
  $ pwd
```
Recibiendo un resultado similar a:
```shell
  $ /home/user/istio-1.18.0
```
4. Agregamos la línea `export PATH=$PATH:${ISTIO_BIN}` a nuestro archivo .bashrc o nuestro archivo _run commands_ de preferencia, donde reemplazamos `${ISTIO_BIN}` por el resultado del paso 3 más `/bin`:
Por ejemplo:
![Exporting istio bin directory](media/export_istio_bin.jpg)
4. Reiniciamos la shell y probamos corriendo el comando `istioctl --help`, deberíamos ver algo similar a:
```shell
  $ istioctl --help
  Istio configuration command line utility for service operators to
  ...
  Use "istioctl [command] --help" for more information about a command.
```

## Instalación del proyecto
Para correr el proyecto, lo único que hace falta es levantar la base de datos y el _cluster_ de Kubernetes. De aquí en adelante, cada sección empieza con su _working directory_ siendo el directorio raíz del proyecto.

### Base de datos
1. Para levantar la base de datos, primero abriremos una terminal y entraremos al directorio `db`:
```shell
  $ cd db
```
2. Luego, levantaremos el _container_ de Docker configurado:
```shell
  $ docker compose up
```
Deberíamos ver una salida similar a:
```shell
[+] Building 0.0s (0/0)
[+] Running 1/0
 ✔ Container postgres  Created 0.0s 
...
postgres  | 2023-06-08 00:51:27.848 UTC [1] LOG:  database system is ready to accept connections

```
3. Si en la salida anterior encontramos lo siguiente ("could not bind IPv4 address"):
```shell
postgres  | 2023-06-08 00:54:27.879 UTC [1] LOG:  could not bind IPv4 address "0.0.0.0": Address already in use
postgres  | 2023-06-08 00:54:27.879 UTC [1] HINT:  Is another postmaster already running on port 5432? If not, wait a few seconds and retry.
```
Significa que nuestro _container_ entró en conflicto con la versión local de postgresql. Por ahora detenemos nuestra instancia local corriendo:
```shell
  $ sudo systemctl stop postgresql
```
Y volvemos a intentar el paso 2.

4. Verificamos una última vez que el _container_ esté corriendo a través del comando `docker ps`:
```shell
  $ docker ps
...   IMAGE                  ...                  CREATED       STATUS         ...                       NAMES
...   postgres:13.3          ...                  5 seconds...  Up 5 seconds   ...                       postgres
```

### Cluster de kubernetes
Lo único que hace falta es correr lo siguiente:
```shell
  $ chmod u+x setup-cluster.sh
  $ ./setup-cluster.sh
```

Pero ahora veremos qué hace cada uno de los comandos y posibles reparaciones de errores, lo cual es más notorio al correrlos por separado:

#### Explicación del script de configuración
1. Creación del cluster
```shell
kind create cluster --config k8s/cluster-config.yaml
```
El comando anterior crea a través de `kind` el _cluster_ de kubernetes. Kind crea los nodos a partir de _containers_ de Docker, por lo que después de correr el comando anterior, si corremos `docker ps`, deberíamos ver 3 nuevos contenedores con nombres "redes-cluster-control-plane", "redes-cluser-worker" y "redes-cluster-worker2".

2. Creación de imágenes de las APIs
```shell
  $ cd ./src/v1 && docker-compose build
  $ cd ../v2 && docker-compose build
```

```
cd ../../
kind load docker-image v1-redes-api v2-redes-api --name redes-cluster

kubectl apply -f src/
kubectl apply -f src/v1/k8s/
kubectl apply -f src/v2/k8s/

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/cloud/deploy.yaml
# kubectl apply -f ingress-nginx/ingress-nginx.yaml
# kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8084:80

istioctl install -y
kubectl apply -f istio/

```

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
