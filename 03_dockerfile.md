# Dockerfile

## node

```sh
docker build -t apetani/node-app .

docker run --rm -p 8080:3000 apetani/node-app
```

## php-fpm

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

## react

```sh
docker build -t apetani/react-app .

docker run --rm -p 8080:80 apetani/react-app
```
