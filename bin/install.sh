#!/bin/bash

cd $(dirname "$0") && cd ..

# Create required directories and copy helper scripts:
source .env
mkdir -p $DATA_PATH $BACKUP_PATH $NGINX_HTML_PATH

cp cron/bin/*.sh /usr/bin
cp .env /usr/bin/.ghost_blog_env

# Get Let's Encrypt free SSL/TLS certificates:
/usr/bin/update_certs.sh

# Add backup and cert update scripts to cron jobs:
crontab cron/crontab.txt

# Setup the firewall:
command -v ufw > /dev/null 2>&1 || {
  apt-get update && apt-get install -y ufw
}

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

