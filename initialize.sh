#!/usr/bin/env bash

# -------------------------
# START user settings START
# -------------------------
# Container name
NAME=ucdn

# Ports
PORT_HTTP=38080
PORT_SSL=30443

# Bind mount
LOGDIR=/apps/ucdn/logs
DATADIR=/apps/ucdn/fileCloud

# User and Group ID (numeric) that owns data/logs [default to 0 (root)]
USERID=0
GROUPID=0
# --------------------
# END user settings END
# ---------------------

if [ ! -d "${LOGDIR}" ]; then
   mkdir ${LOGDIR}
   chown -R ${USERID}:${GROUPID} ${LOGDIR}
fi
if [ ! -d "${DATADIR}" ]; then
   mkdir ${DATADIR}
   chown -R ${USERID}:${GROUPID} ${DATADIR}
fi

# Create container
docker run \
	--detach \
	--restart unless-stopped \
        --user ${USERID}:${GROUPID} \
	--name ${NAME} \
	--publish ${PORT_SSL}:30443 \
	--publish ${PORT_HTTP}:38080 \
	--volume ${DATADIR}:/apps/ucdn/fileCloud \
	--volume ${LOGDIR}:/apps/ucdn/logs \
	cdluc3/ucdn

exit
