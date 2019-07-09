# Docker Workshop

## Hello world

```sh
docker run hello-world

# /usr/share/nginx/html/index.html
docker run --rm -p 8080:80 nginx
```

## Docker CLI

### docker container

Run docker container:

```sh
# /bin/bash becomes PID 1
docker run --rm -it ubuntu /bin/bash
docker run -it -d ubuntu /bin/bash

# node is PID 1
docker run --rm node
```

Attach to running container:

```sh
docker run --rm -it -d --name ubuntu ubuntu /bin/bash

# attach is for attaching to the running process
docker attach ubuntu
docker exec -it ubuntu /bin/bash
docker exec -it ubuntu /bin/bash -c "echo \"Hello Docker\!\" > /tmp/hello.txt"
```

Running multiple containers from an image:

```sh
# containers are isolated
docker run --rm -it -d --name ubuntu1 ubuntu /bin/bash
docker run --rm -it -d --name ubuntu2 ubuntu /bin/bash
```

### docker image

Tag existing image, save it to disk and load from file:

```sh
docker image tag nginx:latest workshop/nginx:latest
docker image save -o nginx.tar workshop/nginx
docker image load --input=nginx.tar
```

### docker network

ping from busybox:

```sh
docker network create workshop

docker run --rm -it -d --name busybox1 busybox
docker network connect workshop busybox1

docker run --rm -it -d --name busybox2 busybox
docker network connect workshop busybox2

docker exec -it busybox2 ping busybox1
```

### docker volume

anonymous volume vs. named volume vs. bind mounts:

```sh
docker run -d -p 8080:80 --name nginx -v /usr/share/nginx/html nginx
docker run -d -p 8080:80 --name nginx -v nginx-data:/usr/share/nginx/html nginx
docker run -d -p 8080:80 --name nginx -v $(pwd)/index.html:/usr/share/nginx/html/index.html nginx
```

backup and restore:

```sh
docker run --rm -p 8080:80 --name nginx -v nginx-data:/usr/share/nginx/html nginx

docker run --rm \
  --volumes-from nginx \
  -v $(pwd):/backup \
  busybox tar cvf /backup/backup.tar /usr/share/nginx/html

docker run --rm \
  --volumes-from nginx \
  -v $(pwd):/backup \
  busybox sh -c "cd /usr/share/nginx/html && tar xvf /backup/backup.tar --strip 4"
```

### node

```sh
docker run --rm \
  -p 8080:3000 \
  -v $(pwd):/var/www \
  -v node_modules:/var/www/node_modules \
  -w "/var/www" \
  node sh -c "npm install && npm start"
```

### php-fpm

```sh
docker network create workshop

docker run --rm -d \
  -v $(pwd)/code:/code \
  --name php --network workshop \
  php:7.3.5-fpm-stretch

docker run --rm -d -p 8080:80 \
  -v $(pwd)/code:/code \
  -v $(pwd)/site.conf:/etc/nginx/conf.d/default.conf \
  --name web --network workshop \
  nginx:1.15.12
```

### react

```sh
docker run --rm \
  -p 8080:3000 \
  -v $(pwd):/app \
  -v node_modules:/app/node_modules \
  -w "/app" \
  node sh -c "npm i && npm start"
```

## Dockerfile

### node

```sh
docker build -t apetani/node-app .

docker run --rm -d apetani/node-app
```

### php-fpm

```sh
docker build -t apetani/php-app -f php.Dockerfile .
docker build -t apetani/nginx-app -f nginx.Dockerfile .

docker network create workshop

docker run --rm -d \
  --name php --network workshop \
  apetani/php-app

docker run --rm -d -p 8080:80 \
  --name web --network workshop \
  apetani/nginx-app
```

### react

```sh
docker build -t apetani/react-app .

docker run --rm -p 8080:80 apetani/react-app
```

## Docker Compose

```sh
# dev
source docker/config/.dev.env
docker-compose -f docker/docker-compose.local.yml -p ${PROJ}_${ENV} up

# stage
source docker/config/.stage.env
docker-compose -f docker/docker-compose.local.yml -p ${PROJ}_${ENV} up

# prod
source docker/config/.prod.env
docker-compose -f docker/docker-compose.prod.yml -p ${PROJ}_${ENV} up --build
```

### Local docker registry using container

```sh
# run a local docker registry
docker run --rm -it -p 5000:5000 \
  -v registry_volume:/var/lib/registry \
  registry:2

docker run \
  --entrypoint htpasswd \
  registry:2 -Bbn user pass > auth/htpasswd

docker run --rm -it -p 5000:5000 \
  -v $(pwd)/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2

docker login http://localhost:5000

# tag image and push to local repository
docker pull nginx:latest
docker tag nginx:latest localhost:5000/nginx:latest
docker push localhost:5000/nginx

# remove image and image tag
docker rmi localhost:5000/nginx:1.15
docker rmi nginx:1.15

# check repositories
curl http://localhost:5000/v2/_catalog
curl http://localhost:5000/v2/nginx/tags/list
```
