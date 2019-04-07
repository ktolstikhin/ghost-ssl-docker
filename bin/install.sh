#!/bin/sh

cd $(dirname "$0") && cd ..

cp cron/bin/*.sh /usr/bin
cp .env /usr/bin/.ghost_blog_env

/usr/bin/update_certs.sh

crontab cron/crontab.txt

