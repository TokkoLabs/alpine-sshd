#!/bin/sh
if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "Need your ssh public key as AUTHORIZED_KEYS env variable. Abnormal exit ..."
  exit 1
fi

echo "Populating /root/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
mkdir /home/user/.ssh/
echo "${AUTHORIZED_KEYS}" > /home/user/.ssh/authorized_keys

chown -R user:group /home/user
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys

echo "export ${KUBERNETES_SERVICE_PORT_HTTPS}" > /home/user/.profile
echo "export ${KUBERNETES_SERVICE_HOST}" > /home/user/.profile
echo "export ${KUBERNETES_SERVICE_PORT}" > /home/user/.profile

# Execute the CMD from the Dockerfile:
exec "$@"

