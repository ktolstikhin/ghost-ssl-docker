#!/bin/sh

period=${1:-daily}

if [ ${period} = daily ]; then
  timestamp=$(date +\%A)
elif [ ${period} = weekly ]; then
  timestamp=$(date -I)
else
  echo "$(date) [ERROR] Unsupported backup period!"
  exit 1
fi

archive=${DATA_PATH}/backup/ghost_backup_${timestamp}.tar.gz

echo "$(date) [INFO] Backup ${DATA_PATH}/data to ${archive}"
tar -zcf ${archive} data -C ${DATA_PATH}

if [ $? -ne 0 ]; then
  echo "$(date) [ERROR] Backup failed!"
  exit 1
fi

