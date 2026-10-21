#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${REGISTRY:-ghcr.io/gorlikitsme}"
IMAGE_NAME="${IMAGE_NAME:-php-nginx}"
PHP_VERSION="${PHP_VERSION:-8.5.12}"
TAG_MINOR="${TAG_MINOR:-8.5}"

PHP_FPM_TAG="${REGISTRY}/php-fpm:${PHP_VERSION}-bookworm"
PHP_TAG="${REGISTRY}/php:${TAG_MINOR}"
FINAL_TAG="${REGISTRY}/${IMAGE_NAME}:${TAG_MINOR}"
FINAL_TAG_FULL="${REGISTRY}/${IMAGE_NAME}:${PHP_VERSION}"

echo "==> Building official PHP ${PHP_VERSION} FPM (bookworm)"
docker build \
  -t "php:${TAG_MINOR}-fpm-bookworm" \
  -t "php:${TAG_MINOR}-fpm" \
  -t "php:${PHP_VERSION}-fpm-bookworm" \
  -t "${PHP_FPM_TAG}" \
  "${ROOT}/docker/php-fpm"

echo "==> Building webdevops/php:${TAG_MINOR}"
docker build \
  -t "webdevops/php:${TAG_MINOR}" \
  -t "webdevops/php-official:${TAG_MINOR}" \
  -t "${PHP_TAG}" \
  "${ROOT}/docker/php"

echo "==> Building ${FINAL_TAG} (PHP ${PHP_VERSION})"
docker build \
  -t "webdevops/php-nginx:${TAG_MINOR}" \
  -t "${FINAL_TAG}" \
  -t "${FINAL_TAG_FULL}" \
  "${ROOT}/docker/php-nginx"

echo "==> Verifying PHP version"
ACTUAL="$(docker run --rm "${FINAL_TAG}" php -r 'echo PHP_VERSION;')"
echo "PHP version in image: ${ACTUAL}"
if [[ "${ACTUAL}" != "${PHP_VERSION}" ]]; then
  echo "ERROR: expected PHP ${PHP_VERSION}, got ${ACTUAL}" >&2
  exit 1
fi

echo "OK: ${FINAL_TAG} and ${FINAL_TAG_FULL}"
