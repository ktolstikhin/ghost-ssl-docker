#!/bin/bash

source $(dirname "$0")/.ghost_blog_env
period=${1:-daily}

if [ $period = daily ]; then
  timestamp=$(date +\%A)
else
  timestamp=$(date -I)
fi

backup_archive=${BACKUP_PATH}/ghost_backup_${timestamp}.tar.gz
echo "$(date) [INFO] Backup $DATA_PATH to $backup_archive"

tar -zcf $backup_archive $DATA_PATH

if [ $? -ne 0 ]; then
  echo "$(date) [ERROR] Backup failed!"
  exit 1
fi

