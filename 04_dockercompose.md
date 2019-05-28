# Docker Compose

## node

```sh
# dev
source .dev.env
docker-compose -f docker-compose.dev.yml up

source .prod.env
docker-compose -f docker-compose.prod.yml up --build
```

## php-fpm

```sh
# dev
source .dev.env
docker-compose -f docker-compose.dev.yml up

source .prod.env
docker-compose -f docker-compose.prod.yml up --build
```

## react

```sh
# dev
source .dev.env
docker-compose -f docker-compose.dev.yml up

source .prod.env
docker-compose -f docker-compose.prod.yml up --build
```