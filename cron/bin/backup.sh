#!/bin/sh

period=${1:-daily}

if [ $period = daily ]; then
  timestamp=$(date +\%A)
elif [ $period = weekly ]; then
  timestamp=$(date -I)
else
  echo "[ERROR] Unsupported backup period!"
  exit 1
fi

data=${DATA_PATH}/data
archive=${DATA_PATH}/backup/ghost_backup_${timestamp}.tar.gz

echo "[INFO] Backup $data to $archive"
tar -zcf $archive $data

if [ $? -ne 0 ]; then
  echo "[ERROR] Backup failed!"
  exit 1
fi

