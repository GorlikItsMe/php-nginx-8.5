# php-nginx 8.5 (PHP 8.5.12)

Drop-in rebuild of [`webdevops/php-nginx:8.5`](https://hub.docker.com/r/webdevops/php-nginx) pinned to **PHP 8.5.12**, built before the upstream Hub tags catch up.

Built from:

1. [docker-library/php](https://github.com/docker-library/php) `8.5/bookworm/fpm` (PHP **8.5.12**)
2. [webdevops/Dockerfile](https://github.com/webdevops/Dockerfile) `php-official/8.5` + `php-nginx/8.5`
3. `webdevops/toolbox` (baselayout, pulled at build time)

## Image

```text
ghcr.io/gorlikitsme/php-nginx:8.5
ghcr.io/gorlikitsme/php-nginx:8.5.12
```

Private package on GHCR (this repo is private). Authenticate, then pull:

```bash
echo "$GITHUB_TOKEN" | docker login ghcr.io -u USERNAME --password-stdin
docker pull ghcr.io/gorlikitsme/php-nginx:8.5
```

Compatible with the usual webdevops env vars (`WEB_DOCUMENT_ROOT`, `WEB_DOCUMENT_INDEX`, …). Ports **80** / **443**.

## Local build

Requires Docker.

```bash
./scripts/build.sh
```

Or step by step:

```bash
docker build -t php:8.5-fpm-bookworm ./docker/php-fpm
docker build -t webdevops/php:8.5 ./docker/php
docker build -t webdevops/php-nginx:8.5 ./docker/php-nginx
docker run --rm webdevops/php-nginx:8.5 php -v
```

## CI

Push to `main` (or run **Build and publish php-nginx** manually) builds the full chain and publishes to GHCR.

## Sources / licenses

- PHP Dockerfiles: docker-library (MIT)
- webdevops layers: [webdevops/Dockerfile](https://github.com/webdevops/Dockerfile) (MIT)
