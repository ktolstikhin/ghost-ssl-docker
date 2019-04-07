#!/bin/sh

period={1:-daily}

if [ $period = daily ]; then
  timestamp=$(date +\%A)
else
  timestamp=$(date -I)
fi

backup_archive=${BACKUP_PATH}/ghost_backup_${timestamp}.tar.gz
echo "$(date) [INFO] Backup $DATA_PATH to $backup_archive"

tar -zcvf $backup_archive $DATA_PATH

if [ $? -ne 0 ]; then
  echo "[ERROR] Backup failed!"
fi

