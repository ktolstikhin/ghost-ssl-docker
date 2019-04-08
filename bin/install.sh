#!/bin/bash

cd $(dirname "$0") && cd ..

source .env
mkdir -p $DATA_PATH $BACKUP_PATH $NGINX_HTML_PATH

cp cron/bin/*.sh /usr/bin
cp .env /usr/bin/.ghost_blog_env

/usr/bin/update_certs.sh

crontab cron/crontab.txt

