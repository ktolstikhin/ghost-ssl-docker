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

if [ -z $DATA_PATH ]; then
  echo "[ERROR] The DATA_PATH is unset!"
  exit 1
fi

for data_dir in $(ls -d ${DATA_PATH}/*_data); do
  name=$(basename $data_dir)
  archive=${DATA_PATH}/backup/${name}_backup_${timestamp}.tar.gz

  echo "[INFO] Backup $data_dir to $archive"
  tar -zcf $archive $data_dir

  if [ $? -ne 0 ]; then
    echo "[ERROR] Backup failed!"
    exit 1
  fi

done

