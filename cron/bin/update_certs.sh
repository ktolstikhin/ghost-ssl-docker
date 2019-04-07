#!/bin/sh

source $(dirname "$0")/.ghost_blog_env
mkdir -p $NGINX_HTML_PATH

echo "$(date) [INFO] Updating certificates..."

docker run \
  -it \
  --rm \
  --name letsencrypt \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "${NGINX_HTML_PATH}:/var/www" \
  quay.io/letsencrypt/letsencrypt:latest \
  auth \
  --authenticator webroot \
  --webroot-path /var/www \
  --renew-by-default \
  --server \
  https://acme-v01.api.letsencrypt.org/directory \
  --domain $DOMAIN_NAME

if [ $? -eq 0 ]; then
  docker exec $NGINX_CONTAINER_NAME nginx -s reload
else
  echo "$(date) [ERROR] Failed to update certificates!"
  exit 1
fi

