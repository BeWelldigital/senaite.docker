#!/bin/bash
set -e

COMMANDS="adduser debug fg foreground help kill logreopen logtail reopen_transcript run show status stop wait"
START="console start restart"

# Fixing permissions for external /data volumes
mkdir -p /data/blobstorage /data/cache /data/filestorage /data/instance /data/log /data/zeoserver
mkdir -p /home/senaite/senaite.patient/src
find /data  -not -user senaite -exec chown senaite:senaite {} \+
find /home/senaite -not -user senaite -exec chown senaite:senaite {} \+

# Initializing from environment variables
gosu senaite python /docker-initialize.py

if [ -e "custom.cfg" ]; then
  if [ ! -e "bin/develop" ]; then
    buildout -c custom.cfg
    find /data  -not -user senaite -exec chown senaite:senaite {} \+
    find /home/senaite -not -user senaite -exec chown senaite:senaite {} \+
    gosu senaite python /docker-initialize.py
  fi
fi

exec gosu senaite bin/instance fg

# # ZEO Server
# if [[ "$1" == "zeo"* ]]; then
#   exec gosu senaite bin/$1 fg
# fi

# # Instance start
# if [[ $START == *"$1"* ]]; then
#   exec gosu senaite bin/instance console
# fi

# # Instance helpers
# if [[ $COMMANDS == *"$1"* ]]; then
#   exec gosu senaite bin/instance "$@"
# fi

# Custom
exec "$@"
