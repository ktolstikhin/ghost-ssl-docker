#!/bin/bash

cd $(dirname "$0") && cd ..

# Create required directories and copy helper scripts:
source .env
mkdir -p $DATA_PATH $BACKUP_PATH $NGINX_HTML_PATH

cp cron/bin/*.sh /usr/bin
cp .env /usr/bin/.ghost_blog_env

# Get Let's Encrypt free SSL/TLS certificates:
/usr/bin/update_certs.sh

# Add backup and certificate update scripts to cron jobs:
crontab cron/crontab.txt

