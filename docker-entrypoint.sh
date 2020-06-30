#!/bin/sh
if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "Need your ssh public key as AUTHORIZED_KEYS env variable. Abnormal exit ..."
  exit 1
fi

echo "Populating /root/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
mkdir -p /home/user/.ssh/
echo "${AUTHORIZED_KEYS}" > /home/user/.ssh/authorized_keys

# Execute the CMD from the Dockerfile:
exec "$@"

